{ pkgs, ... }:
{
  networking = {
    hostName = "happuter";
    networkmanager = {
      enable = true;
      wifi.scanRandMacAddress = false;
      dispatcherScripts = [
        {
          # When a physical interface comes up, wait for Tailscale to get its
          # IP and then start Caddy. This recovers from the boot race where
          # WiFi connects too slowly for the one-shot wait service to succeed.
          source = pkgs.writeShellScript "caddy-on-network-up" ''
            IFACE=$1
            ACTION=$2

            [ "$ACTION" = "up" ] || exit 0

            case "$IFACE" in
              docker*|br-*|veth*|lo|tailscale*) exit 0 ;;
            esac

            for i in $(seq 1 120); do
              if ${pkgs.iproute2}/bin/ip addr show tailscale0 2>/dev/null | grep -q "100.107.157.33"; then
                systemctl reset-failed wait-for-tailscale-ip.service docker-caddy.service 2>/dev/null || true
                systemctl start docker-caddy.service
                exit 0
              fi
              sleep 1
            done
            exit 1
          '';
          type = "basic";
        }
      ];
    };
  };

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 25565 ];
    trustedInterfaces = [ "tailscale0" "br-services" ];
    # nftables fib (used by nixos-fw-rpfilter) only checks the main routing
    # table, not policy routing tables. Tailscale peer routes live exclusively
    # in table 52, so strict rpfilter drops every inbound Tailscale packet
    # before DNAT fires. Loose mode passes if *any* route to the source exists.
    checkReversePath = "loose";
    extraCommands = ''
      iptables -A FORWARD -i tailscale0 -j ACCEPT
    '';
    extraStopCommands = ''
      iptables -D FORWARD -i tailscale0 -j ACCEPT 2>/dev/null || true
    '';
  };

  programs.ssh.startAgent = true;
}
