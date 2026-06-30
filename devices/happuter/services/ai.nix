{ pkgs, lib, ... }:
let
  qwen3Template = pkgs.writeText "qwen3-coder.jinja" ''
    {% macro render_extra_keys(json_dict, handled_keys) %}
        {%- if json_dict is mapping %}
            {%- for json_key in json_dict if json_key not in handled_keys %}
                {%- if json_dict[json_key] is mapping or (json_dict[json_key] is sequence and json_dict[json_key] is not string) %}
                    {{- '\n<' ~ json_key ~ '>' ~ (json_dict[json_key] | tojson | safe) ~ '</' ~ json_key ~ '>' }}
                {%- else %}
                    {{-'\n<' ~ json_key ~ '>' ~ (json_dict[json_key] | string) ~ '</' ~ json_key ~ '>' }}
                {%- endif %}
            {%- endfor %}
        {%- endif %}
    {% endmacro %}

    {%- if messages[0]["role"] == "system" %}
        {%- set system_message = messages[0]["content"] %}
        {%- set loop_messages = messages[1:] %}
    {%- else %}
        {%- set loop_messages = messages %}
    {%- endif %}

    {%- if not tools is defined %}
        {%- set tools = [] %}
    {%- endif %}

    {%- if system_message is defined %}
        {{- "<|im_start|>system\n" + system_message }}
    {%- else %}
        {%- if tools is iterable and tools | length > 0 %}
            {{- "<|im_start|>system\nYou are Qwen, a helpful AI assistant that can interact with a computer to solve tasks." }}
        {%- endif %}
    {%- endif %}
    {%- if tools is iterable and tools | length > 0 %}
        {{- "\n\n# Tools\n\nYou have access to the following functions:\n\n" }}
        {{- "<tools>" }}
        {%- for tool in tools %}
            {%- if tool.function is defined %}
                {%- set tool = tool.function %}
            {%- endif %}
            {{- "\n<function>\n<name>" ~ tool.name ~ "</name>" }}
            {%- if tool.description is defined %}
                {{- '\n<description>' ~ (tool.description | trim) ~ '</description>' }}
            {%- endif %}
            {{- '\n<parameters>' }}
            {%- if tool.parameters is defined and tool.parameters is mapping and tool.parameters.properties is defined and tool.parameters.properties is mapping %}
                {%- for param_name, param_fields in tool.parameters.properties|items %}
                    {{- '\n<parameter>' }}
                    {{- '\n<name>' ~ param_name ~ '</name>' }}
                    {%- if param_fields.type is defined %}
                        {{- '\n<type>' ~ (param_fields.type | string) ~ '</type>' }}
                    {%- endif %}
                    {%- if param_fields.description is defined %}
                        {{- '\n<description>' ~ (param_fields.description | trim) ~ '</description>' }}
                    {%- endif %}
                    {%- set handled_keys = ['name', 'type', 'description'] %}
                    {{- render_extra_keys(param_fields, handled_keys) }}
                    {{- '\n</parameter>' }}
                {%- endfor %}
            {%- endif %}
            {%- set handled_keys = ['type', 'properties'] %}
            {{- render_extra_keys(tool.parameters, handled_keys) }}
            {{- '\n</parameters>' }}
            {%- set handled_keys = ['type', 'name', 'description', 'parameters'] %}
            {{- render_extra_keys(tool, handled_keys) }}
            {{- '\n</function>' }}
        {%- endfor %}
        {{- "\n</tools>" }}
        {{- '\n\nIf you choose to call a function ONLY reply in the following format with NO suffix:\n\n<tool_call>\n<function=example_function_name>\n<parameter=example_parameter_1>\nvalue_1\n</parameter>\n<parameter=example_parameter_2>\nThis is the value for the second parameter\nthat can span\nmultiple lines\n</parameter>\n</function>\n</tool_call>\n\n<IMPORTANT>\nReminder:\n- Function calls MUST follow the specified format: an inner <function=...></function> block must be nested within <tool_call></tool_call> XML tags\n- Required parameters MUST be specified\n- You may provide optional reasoning for your function call in natural language BEFORE the function call, but NOT after\n- If there is no function call available, answer the question like normal with your current knowledge and do not tell the user about function calls\n</IMPORTANT>' }}
    {%- endif %}
    {%- if system_message is defined %}
        {{- '<|im_end|>\n' }}
    {%- else %}
        {%- if tools is iterable and tools | length > 0 %}
            {{- '<|im_end|>\n' }}
        {%- endif %}
    {%- endif %}
    {%- for message in loop_messages %}
        {%- if message.role == "assistant" and message.tool_calls is defined and message.tool_calls is iterable and message.tool_calls | length > 0 %}
            {{- '<|im_start|>' + message.role }}
            {%- if message.content is defined and message.content is string and message.content | trim | length > 0 %}
                {{- '\n' + message.content | trim + '\n' }}
            {%- endif %}
            {%- for tool_call in message.tool_calls %}
                {%- if tool_call.function is defined %}
                    {%- set tool_call = tool_call.function %}
                {%- endif %}
                {{- '\n<tool_call>\n<function=' + tool_call.name + '>\n' }}
                {%- if tool_call.arguments is defined %}
                    {%- for args_name, args_value in tool_call.arguments|items %}
                        {{- '<parameter=' + args_name + '>\n' }}
                        {%- set args_value = args_value | tojson | safe if args_value is mapping or (args_value is sequence and args_value is not string) else args_value | string %}
                        {{- args_value }}
                        {{- '\n</parameter>\n' }}
                    {%- endfor %}
                {%- endif %}
                {{- '</function>\n</tool_call>' }}
            {%- endfor %}
            {{- '<|im_end|>\n' }}
        {%- elif message.role == "user" or message.role == "system" or message.role == "assistant" %}
            {{- '<|im_start|>' + message.role + '\n' + message.content + '<|im_end|>' + '\n' }}
        {%- elif message.role == "tool" %}
            {%- if loop.previtem and loop.previtem.role != "tool" %}
                {{- '<|im_start|>user\n' }}
            {%- endif %}
            {{- '<tool_response>\n' }}
            {{- message.content }}
            {{- '\n</tool_response>\n' }}
            {%- if not loop.last and loop.nextitem.role != "tool" %}
                {{- '<|im_end|>\n' }}
            {%- elif loop.last %}
                {{- '<|im_end|>\n' }}
            {%- endif %}
        {%- else %}
            {{- '<|im_start|>' + message.role + '\n' + message.content + '<|im_end|>\n' }}
        {%- endif %}
    {%- endfor %}
    {%- if add_generation_prompt %}
        {{- '<|im_start|>assistant\n' }}
    {%- endif %}
  '';

  modelPreset = pkgs.writeText "llama-models.ini" ''
    [DEFAULT]
    n-gpu-layers = -1
    flash-attn = on

    [qwen3-coder]
    model = /mnt/happssd/ollama/models/blobs/sha256-30c83da425db2324444b6a6cecaf4c410038a2ec73a78de2436879dc0316a371
    ctx-size = 65536
    chat-template-file = ${qwen3Template}
    jinja = on
    cache-type-k = q4_0
    cache-type-v = q4_0
    sleep-idle-seconds = 10


    [gemma4]
    model = /mnt/happssd/ollama/models/blobs/sha256-88c462c244956232cc947ca61a95db3b52cb7d12c4dbc49cd46403018610000f
    mmproj = /mnt/happssd/ollama/models/blobs/sha256-9422eeb070cc7f6e412d34d03e2fb4693bb90dcdba4a0294150de28a04f4e12c
    ctx-size = 8192
  '';
in
{
  virtualisation.oci-containers.containers.open-webui = {
    image = "ghcr.io/open-webui/open-webui:main";
    volumes = [ "/var/lib/open-webui/data:/app/backend/data" ];
    environment = {
      OLLAMA_BASE_URL                     = "http://100.107.157.33:11434";
      CHAT_RESPONSE_MAX_TOOL_CALL_RETRIES = "200";
      TOOL_RESULT_MAX_CHARS               = "50000";
      TOOL_RESULT_PREVIEW_CHARS           = "2000";
    };
    extraOptions = [ "--network=services" ];
  };

  systemd.services."docker-open-webui" = {
    requires = [ "docker-network-services.service" "ollama.service" ];
    after    = [ "docker-network-services.service" "ollama.service" ];
  };

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    host   = "0.0.0.0";
    port   = 11434;
    models = "/mnt/happssd/ollama/models";
    environmentVariables.OLLAMA_KEEP_ALIVE = "0";
  };

  systemd.services.ollama = {
    requires = [ "mnt-happssd.mount" ];
    after    = [ "mnt-happssd.mount" ];
  };

  systemd.services.llama-server = {
    description = "llama.cpp inference server";
    after    = [ "mnt-happssd.mount" "network.target" ];
    requires = [ "mnt-happssd.mount" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.llama-cpp-rocm}/bin/llama-server --models-preset ${modelPreset} --host 0.0.0.0 --port 11436";
      Restart    = "on-failure";
      RestartSec = "5s";
    };
  };

  environment.systemPackages = [
    pkgs.opencode
    pkgs.rocmPackages.rocm-smi
  ];

  happuter.caddy.virtualHosts."openwebui.meihapps.gay" = "reverse_proxy open-webui:8080";
}
