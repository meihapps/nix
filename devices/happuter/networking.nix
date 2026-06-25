{ pkgs, ... }:
{
  networking = {
    hostName = "happuter";
    networkmanager = {
      enable = true;
      wifi.scanRandMacAddress = false;
      dispatcherScripts = [
        {
          # When the Mullvad Personal toggle interface (wg-personal) comes up
          # or down, add or remove the default route via the always-on tunnel.
          #
          # On up: first pin the Mullvad endpoint to the physical NIC so that
          # WireGuard's own keepalive/handshake traffic doesn't loop back into
          # the tunnel once the default route points at wg-mullvad.
          source = pkgs.writeShellScript "mullvad-personal-toggle" ''
            [ "$1" = "wg-personal" ] || exit 0
            ip="${pkgs.iproute2}/bin/ip"
            awk="${pkgs.gawk}/bin/awk"
            mullvad_endpoint="142.147.89.210"
            case "$2" in
              up)
                gw=$($ip route show table main \
                  | $awk '/^default/ && !/dev wg/ && !/dev tun/ && !/dev ppp/ {print $3; exit}')
                dev=$($ip route show table main \
                  | $awk '/^default/ && !/dev wg/ && !/dev tun/ && !/dev ppp/ {print $5; exit}')
                [ -n "$gw" ] && [ -n "$dev" ] && \
                  $ip route replace "$mullvad_endpoint/32" via "$gw" dev "$dev"
                $ip route replace default dev wg-mullvad
                $ip -6 route replace default dev wg-mullvad
                ;;
              down)
                $ip route del "$mullvad_endpoint/32" 2>/dev/null || true
                $ip route del default dev wg-mullvad 2>/dev/null || true
                $ip -6 route del default dev wg-mullvad 2>/dev/null || true
                ;;
            esac
          '';
          type = "basic";
        }
        {
          # When a physical interface comes up, wait for Tailscale to get its
          # IP and then start Caddy. This recovers from the boot race where
          # WiFi connects too slowly for the one-shot wait service to succeed.
          source = pkgs.writeShellScript "caddy-on-network-up" ''
            IFACE=$1
            ACTION=$2

            [ "$ACTION" = "up" ] || exit 0

            case "$IFACE" in
              docker*|br-*|veth*|lo|tailscale*|wg-*) exit 0 ;;
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
      iptables -A INPUT -i br-services -j ACCEPT
    '';
    extraStopCommands = ''
      iptables -D FORWARD -i tailscale0 -j ACCEPT 2>/dev/null || true
      iptables -D INPUT -i br-services -j ACCEPT 2>/dev/null || true
    '';
  };

}
