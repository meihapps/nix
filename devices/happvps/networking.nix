{ ... }:
{
  networking.hostName = "happvps";
  networking.useDHCP = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
    trustedInterfaces = [ "tailscale0" ];
    checkReversePath = "loose";
  };

  time.timeZone = "UTC";
}
