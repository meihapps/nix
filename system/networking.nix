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

  networking.firewall.enable = true;

  programs.ssh.startAgent = true;
}
