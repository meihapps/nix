{ config, pkgs, ... }:
{
  age.secrets.porkbun-api-key.file = ../../../secrets/porkbun-api-key.age;
  age.secrets.porkbun-secret-key.file = ../../../secrets/porkbun-secret-key.age;

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/porkbun@v0.3.1" ];
      hash = "sha256-3XnnBdOW8A+LmmcqR94v1ZkyMoMB3EfBWFv0uBzz4cA=";
    };
    # Tailnet-only names resolve to a 100.x address, which Let's Encrypt can't
    # reach, so they need the DNS challenge. Port 443 is still open publicly, so
    # the source IP is checked too: a matching hostname alone must not get in.
    extraConfig = ''
      (tailnet) {
        tls {
          dns porkbun {
            api_key {env.PORKBUN_API_KEY}
            api_secret_key {env.PORKBUN_API_SECRET}
          }
        }
        @external not remote_ip 100.64.0.0/10 fd7a:115c:a1e0::/48
        abort @external
      }
    '';
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = [
    config.age.secrets.porkbun-api-key.path
    config.age.secrets.porkbun-secret-key.path
  ];
}
