{ config, ... }:
{
  age.secrets.plausible-secret-key = {
    file = ../../secrets/plausible-secret-key.age;
    owner = "plausible";
  };

  services.plausible = {
    enable = true;
    server = {
      baseUrl = "https://analytics.meihapps.gay";
      secretKeybaseFile = config.age.secrets.plausible-secret-key.path;
    };
    mail.email = "mail@meihapps.gay";
  };

  services.caddy.virtualHosts."analytics.meihapps.gay".extraConfig = ''
    reverse_proxy 127.0.0.1:8000
  '';
}
