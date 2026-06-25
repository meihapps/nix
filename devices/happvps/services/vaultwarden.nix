{ config, ... }:
{
  age.secrets.vaultwarden-admin-token = {
    file = ../../../secrets/vaultwarden-admin-token.age;
    owner = "vaultwarden";
  };

  services.vaultwarden = {
    enable = true;
    environmentFile = config.age.secrets.vaultwarden-admin-token.path;
    config = {
      DOMAIN = "https://passwords.meihapps.gay";
      SIGNUPS_ALLOWED = false;
      ROCKET_PORT = 8222;
      ROCKET_ADDRESS = "127.0.0.1";
    };
  };

  services.caddy.virtualHosts."passwords.meihapps.gay".extraConfig = ''
    reverse_proxy 127.0.0.1:8222
  '';
}
