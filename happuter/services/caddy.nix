{ pkgs, config, lib, ... }:
let
  tailscaleIP = "100.107.157.33";
in
{
  options.happuter.caddy.virtualHosts = lib.mkOption {
    type = lib.types.attrsOf lib.types.lines;
    default = {};
  };

  config = {

  # Caddy is bound to the Tailscale IP so it's only reachable from your own
  # devices, not the public internet. The wait service below guards against
  # Docker trying to bind the port before tailscale0 has acquired its IP.
  systemd.services.wait-for-tailscale-ip = {
    description = "Wait for Tailscale IP ${tailscaleIP} to be available";
    after = [ "tailscaled.service" ];
    requires = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "wait-for-tailscale-ip" ''
        for i in $(seq 1 60); do
          if ${pkgs.iproute2}/bin/ip addr show tailscale0 2>/dev/null | grep -q "${tailscaleIP}"; then
            exit 0
          fi
          sleep 1
        done
        echo "Timed out waiting for Tailscale IP ${tailscaleIP}" >&2
        exit 1
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/caddy 0755 root root -"
  ];

  age.secrets.porkbun-api-key = {
    file = ../../secrets/porkbun-api-key.age;
    mode = "0444";
  };

  age.secrets.porkbun-secret-key = {
    file = ../../secrets/porkbun-secret-key.age;
    mode = "0444";
  };

  environment.etc."caddy/Caddyfile".text =
    let
      vhostBlock = host: body:
        let indented = lib.replaceStrings ["\n"] ["\n  "] (lib.trim body);
        in "${host} {\n  ${indented}\n}";
    in ''
      {
        acme_dns porkbun {
          api_key {$PORKBUN_API_KEY}
          api_secret_key {$PORKBUN_API_SECRET}
        }
      }

      ${lib.concatStringsSep "\n\n" (lib.mapAttrsToList vhostBlock config.happuter.caddy.virtualHosts)}
    '';

  virtualisation.oci-containers.containers.caddy = {
    image = "docker.io/serfriz/caddy-porkbun:latest";
    ports = [
      "${tailscaleIP}:80:80"
      "${tailscaleIP}:443:443"
    ];
    environmentFiles = [
      config.age.secrets.porkbun-api-key.path
      config.age.secrets.porkbun-secret-key.path
    ];
    volumes = [
      "/etc/caddy/Caddyfile:/etc/caddy/Caddyfile:ro"
      "/var/lib/caddy:/data"
    ];
    extraOptions = [ "--network=services" ];
  };

  systemd.services."docker-caddy" = {
    requires = [ "docker-network-services.service" "wait-for-tailscale-ip.service" ];
    after = [ "docker-network-services.service" "wait-for-tailscale-ip.service" ];
  };

  }; # config
}
