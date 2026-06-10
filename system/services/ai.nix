{ pkgs, lib, ... }:
let
  kani = pkgs.python3Packages.buildPythonPackage rec {
    pname = "kani";
    version = "1.1.0";
    pyproject = true;

    src = pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-S4F/CmHx+LAjU8gBbncXLPlCtRe916/8z0d3olVrlHM=";
    };

    build-system = [ pkgs.python3Packages.hatchling ];

    dependencies = with pkgs.python3Packages; [
      pydantic
      openai   # enables Ollama via its OpenAI-compatible API
      tiktoken
    ];
  };

  kaniEnv = pkgs.python3.withPackages (ps: [
    kani
    ps.aiohttp
  ]);

  # Routing server: uses kani (qwen3:4b) to classify each task as
  # code/smart/fast, then forwards the full conversation to the
  # appropriate qwen3 model. Exposes an OpenAI-compatible API on :11435
  # so opencode sees a single "kani" provider.
  kaniRouter = pkgs.writeTextFile {
    name = "kani-router";
    executable = true;
    destination = "/bin/kani-router";
    text = ''
      #!${kaniEnv}/bin/python3
      import json, logging
      from aiohttp import web
      from kani import Kani, ChatMessage, ChatRole
      from kani.engines.openai import OpenAIEngine

      OLLAMA = "http://127.0.0.1:11434/v1"
      PORT   = 11435

      MODELS = {
          "code":  "hf.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:Q3_K_M",
          "smart": "qwen3:8b",
          "fast":  "qwen3:4b",
      }

      CLASSIFIER_PROMPT = (
          "Classify the task described in the user message as exactly one of: "
          "code (programming, debugging, writing functions, technical implementation), "
          "smart (complex reasoning, analysis, long-form writing, research), "
          "fast (simple questions, quick lookups, short answers). "
          "Reply with ONLY that single word."
      )

      _classifier_engine = OpenAIEngine(
          api_key="ollama", model=MODELS["fast"], api_base=OLLAMA,
          max_context_size=8192,
      )
      _model_engines = {
          k: OpenAIEngine(api_key="ollama", model=v, api_base=OLLAMA,
                          max_context_size=32768)
          for k, v in MODELS.items()
      }

      ROLE_MAP = {
          "system":    ChatRole.SYSTEM,
          "user":      ChatRole.USER,
          "assistant": ChatRole.ASSISTANT,
      }

      async def classify(last_user: str) -> str:
          ai = Kani(_classifier_engine, system_prompt=CLASSIFIER_PROMPT)
          result = await ai.chat_round_str(last_user)
          word = result.strip().lower().split()[0] if result.strip() else "smart"
          return word if word in MODELS else "smart"

      def build_kani(engine, messages: list):
          system = next(
              (m["content"] for m in messages if m.get("role") == "system"), None
          )
          history = [
              ChatMessage(role=ROLE_MAP[m["role"]], content=m["content"])
              for m in messages[:-1]
              if m.get("role") in ROLE_MAP
          ]
          last_msg = messages[-1]["content"] if messages else ""
          return Kani(engine, system_prompt=system, chat_history=history), last_msg

      async def handle_chat(req: web.Request) -> web.Response:
          body      = await req.json()
          messages  = body.get("messages", [])
          do_stream = body.get("stream", False)

          last_user = next(
              (m["content"] for m in reversed(messages) if m.get("role") == "user"), ""
          )
          category = await classify(last_user)
          ai, last_msg = build_kani(_model_engines[category], messages)

          if do_stream:
              resp = web.StreamResponse(headers={
                  "Content-Type": "text/event-stream",
                  "Cache-Control": "no-cache",
              })
              await resp.prepare(req)
              async for stream in ai.full_round_stream(last_msg):
                  async for token in stream:
                      chunk = {"choices": [{"delta": {"content": token}, "finish_reason": None}]}
                      await resp.write(f"data: {json.dumps(chunk)}\n\n".encode())
              await resp.write(b"data: [DONE]\n\n")
              return resp
          else:
              result = await ai.chat_round_str(last_msg)
              payload = {
                  "object": "chat.completion",
                  "model": f"kani-{category}",
                  "choices": [{"message": {"role": "assistant", "content": result}, "finish_reason": "stop", "index": 0}],
              }
              return web.json_response(payload)

      async def handle_models(_: web.Request) -> web.Response:
          return web.json_response({"object": "list", "data": [{"id": "kani", "object": "model"}]})

      app = web.Application()
      app.router.add_post("/v1/chat/completions", handle_chat)
      app.router.add_get("/v1/models", handle_models)

      logging.basicConfig(level=logging.INFO)
      web.run_app(app, host="127.0.0.1", port=PORT)
    '';
  };
in
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    host   = "127.0.0.1";
    port   = 11434;
    models = "/mnt/happssd/ollama/models";
    environmentVariables.OLLAMA_KEEP_ALIVE = "0";
  };

  systemd.services.ollama = {
    requires = [ "mnt-happssd.mount" ];
    after    = [ "mnt-happssd.mount" ];
  };

  systemd.services.kani-router = {
    description = "Kani model routing server";
    after    = [ "ollama.service" "network.target" ];
    requires = [ "ollama.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart     = "${kaniRouter}/bin/kani-router";
      Restart       = "on-failure";
      RestartSec    = "5s";
      DynamicUser   = true;
    };
  };

  environment.systemPackages = [
    pkgs.opencode
    kaniEnv
  ];
}
