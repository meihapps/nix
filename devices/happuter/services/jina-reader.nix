{ ... }:
{
  virtualisation.oci-containers.containers.jina-reader = {
    image = "ghcr.io/jina-ai/reader:latest";
    extraOptions = [ "--network=services" ];
  };

  systemd.services."docker-jina-reader" = {
    requires = [ "docker-network-services.service" ];
    after = [ "docker-network-services.service" ];
  };

  happuter.caddy.virtualHosts."jina.meihapps.gay" = "reverse_proxy jina-reader:8081";
}
