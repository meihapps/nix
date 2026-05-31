{ pkgs, ... }:
let
  ip = "${pkgs.iproute2}/bin/ip";
  awk = "${pkgs.gawk}/bin/awk";
in
{
  imports = [
    ./caddy.nix
    ./flaresolverr.nix
    ./jellyfin.nix
    ./lidarr.nix
    ./prowlarr.nix
    ./qbittorrent.nix
    ./slskd.nix
    ./ssh.nix
    ./tailscale.nix
  ];

  age.identityPaths = [ "/home/mei/.ssh/id_ed25519" ];

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  virtualisation.oci-containers.backend = "docker";

  # Create the shared Docker bridge all service containers attach to.
  # The bridge name is fixed so it can be referenced by the policy routing service.
  systemd.services.docker-network-services = {
    description = "Create services Docker bridge network";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "docker-network-services-start" ''
        ${pkgs.docker}/bin/docker network inspect services >/dev/null 2>&1 || \
          ${pkgs.docker}/bin/docker network create \
            --driver bridge \
            --subnet 172.20.0.0/16 \
            --opt com.docker.network.bridge.name=br-services \
            services
      '';
    };
  };

  # Keep container egress on the physical NIC so that toggling a personal VPN
  # on the host never affects service traffic. Detects the physical default
  # gateway at runtime by skipping known VPN interface prefixes.
  systemd.services.services-policy-routing = {
    description = "Policy routing for services Docker network";
    after = [ "network-online.target" "docker-network-services.service" ];
    wants = [ "network-online.target" ];
    requires = [ "docker-network-services.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "services-policy-routing-start" ''
        gateway=$(${ip} route show table main \
          | ${awk} '/^default/ && !/dev wg/ && !/dev tun/ && !/dev ppp/ {print $3; exit}')
        device=$(${ip} route show table main \
          | ${awk} '/^default/ && !/dev wg/ && !/dev tun/ && !/dev ppp/ {print $5; exit}')
        if [ -z "$gateway" ] || [ -z "$device" ]; then
          echo "Could not find physical default gateway" >&2
          exit 1
        fi
        ${ip} route replace default via "$gateway" dev "$device" table 200
        ${ip} rule del from 172.20.0.0/16 table 200 priority 100 2>/dev/null || true
        ${ip} rule add from 172.20.0.0/16 table 200 priority 100
      '';
      ExecStop = pkgs.writeShellScript "services-policy-routing-stop" ''
        ${ip} rule del from 172.20.0.0/16 table 200 priority 100 2>/dev/null || true
        ${ip} route flush table 200 2>/dev/null || true
      '';
    };
  };
}
