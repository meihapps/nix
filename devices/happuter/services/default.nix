{ pkgs, ... }:
let
  ip = "${pkgs.iproute2}/bin/ip";
  awk = "${pkgs.gawk}/bin/awk";
in
{
  imports = [
    ./ai.nix
    ./computer-use.nix
    ./caddy.nix
    ./jina-reader.nix
    ./flaresolverr.nix
    ./gost.nix
    ./jellyfin.nix
    ./lidarr.nix
    ./prowlarr.nix
    ./qbittorrent.nix
    ./slskd.nix
  ];

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      flags = [ "--all" ];
    };
  };

  systemd.services.docker-prune-on-boot = {
    description = "Prune unused Docker images on boot";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.docker}/bin/docker image prune --all --force";
    };
  };

  # Docker 29's nftables firewall backend needs `nft` at runtime to install
  # FORWARD rules for bridge networks. Its restricted systemd PATH omits both
  # nftables and iptables, so the backend fails silently and no ACCEPT rules
  # are ever created — blocking all inter-container traffic.
  systemd.services.docker.path = with pkgs; [ nftables iptables ];

  # With bridge-nf-call-iptables=1, all bridged traffic goes through netfilter
  # and hits the FORWARD chain. Docker is supposed to insert ACCEPT rules there,
  # but when it fails to do so reliably, container-to-container traffic is
  # dropped. Setting these to 0 makes the kernel bypass netfilter entirely for
  # same-bridge traffic — all containers on br-services can reach each other
  # without going through iptables/nftables at all.
  boot.kernel.sysctl = {
    "net.bridge.bridge-nf-call-iptables" = 0;
    "net.bridge.bridge-nf-call-ip6tables" = 0;
  };

  virtualisation.oci-containers.backend = "docker";

  systemd.tmpfiles.rules = [
    "z /mnt/happssd 0755 mei users - -"
  ];

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

  # Keep service container egress on the physical NIC regardless of the
  # personal VPN toggle. qbittorrent (172.20.0.200) is exempted and always
  # routed through wg-mullvad via table 201 instead.
  systemd.services.services-policy-routing = {
    description = "Policy routing for services Docker network";
    after = [ "network-online.target" "docker-network-services.service" "wireguard-wg-mullvad.service" ];
    wants = [ "network-online.target" "wireguard-wg-mullvad.service" ];
    requires = [ "docker-network-services.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = "10s";
      StartLimitIntervalSec = "0";
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
        # Tailscale reply traffic must go through tailscale0, not the physical NIC.
        # Tailscale stores peer routes in table 52, not main — use that directly.
        ${ip} rule del from 172.20.0.0/16 to 100.64.0.0/10 priority 50 2>/dev/null || true
        ${ip} rule add from 172.20.0.0/16 to 100.64.0.0/10 priority 50 lookup 52
        # qbittorrent (172.20.0.200) always routes through wg-mullvad via
        # table 201. The tunnel is always up so there's no blackhole fallback
        # needed, but we include one as a safety net if wireguard ever fails.
        ${ip} rule del from 172.20.0.200 table 201 priority 85 2>/dev/null || true
        ${ip} rule add from 172.20.0.200 table 201 priority 85
        ${ip} rule del from 172.20.0.200 blackhole priority 95 2>/dev/null || true
        ${ip} rule add from 172.20.0.200 blackhole priority 95
        # Repopulate table 201 in case this service restarted after wireguard's
        # postSetup already ran (route was flushed on stop).
        ${ip} route replace default dev wg-mullvad table 201 2>/dev/null || true
      '';
      ExecStop = pkgs.writeShellScript "services-policy-routing-stop" ''
        ${ip} rule del from 172.20.0.0/16 table 200 priority 100 2>/dev/null || true
        ${ip} rule del from 172.20.0.0/16 to 100.64.0.0/10 priority 50 2>/dev/null || true
        ${ip} route flush table 200 2>/dev/null || true
        ${ip} rule del from 172.20.0.200 table 201 priority 85 2>/dev/null || true
        ${ip} rule del from 172.20.0.200 blackhole priority 95 2>/dev/null || true
        ${ip} route flush table 201 2>/dev/null || true
      '';
    };
  };
}
