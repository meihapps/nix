{ pkgs, ... }:
{
  systemd.services.plausible-secret-keygen = {
    description = "Generate Plausible secret key on first boot";
    wantedBy = [ "plausible.service" ];
    before = [ "plausible.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if [ ! -f /var/lib/plausible-secret-key ]; then
        ${pkgs.openssl}/bin/openssl rand -base64 64 > /var/lib/plausible-secret-key
        chmod 600 /var/lib/plausible-secret-key
      fi
    '';
  };

  services.plausible = {
    enable = true;
    server = {
      baseUrl = "https://analytics.meihapps.gay";
      secretKeybaseFile = "/var/lib/plausible-secret-key";
    };
    mail.email = "mail@meihapps.gay";
  };

  services.caddy.virtualHosts."analytics.meihapps.gay".extraConfig = ''
    reverse_proxy 127.0.0.1:8000
  '';
}
