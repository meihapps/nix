{ pkgs, ... }:
{
  networking = {
    hostName = "happuter";
    networkmanager.enable = true;
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
