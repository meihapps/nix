{ ... }:
{
  virtualisation.oci-containers.containers.flaresolverr = {
    image = "ghcr.io/flaresolverr/flaresolverr:latest";
    environment = {
      LOG_LEVEL = "info";
      CAPTCHA_SOLVER = "none";
      TZ = "Europe/London";
    };
    extraOptions = [ "--network=services" ];
  };

  systemd.services."docker-flaresolverr" = {
    requires = [ "docker-network-services.service" ];
    after = [ "docker-network-services.service" ];
  };
}
