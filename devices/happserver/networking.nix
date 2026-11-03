{ ... }:
{
  networking.hostName = "happserver";
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
    trustedInterfaces = [ "tailscale0" ];
    checkReversePath = "loose";
  };

  time.timeZone = "UTC";
}
