{ pkgs, lib, ... }:
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

  environment.systemPackages = [
    pkgs.opencode
    pkgs.rocmPackages.rocm-smi
  ];

  happuter.caddy.virtualHosts."openwebui.meihapps.gay" = "reverse_proxy open-webui:8080";
}
