{ pkgs, inputs, ... }:

let
  llama = inputs.llama-cpp.packages.${pkgs.system}.rocm;
in
{
  environment.systemPackages = [
    llama
  ];

  systemd.services.llama-server = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      ExecStart = ''
        ${llama}/bin/llama-server \
          --model /mnt/happssd/llama/model.gguf \
          --mmproj /mnt/happssd/llama/mmproj-F16.gguf
          --host 127.0.0.1 \
          --port 8080 \
          --n-gpu-layers 999 \
          --ctx-size 16384 \
          --batch-size 2048 \
          --ubatch-size 2048 \
          --threads 12 \
          --parallel 1 \
          --cont-batching \
          --jinja \
          --flash-attn on \
          --cache-type-k q8_0 \
          --cache-type-v q8_0 \
          --kv-unified
      '';

      Restart = "on-failure";
      RestartSec = 5;

      SupplementaryGroups = [
        "video"
        "render"
      ];
    };
  };

  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    port = 3000;

    environment = {
      OPENAI_API_BASE_URL = "http://127.0.0.1:8080/v1";
      OPENAI_API_KEY = "none";
    };
  };
}
