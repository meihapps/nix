{ ... }:
{
  networking.hostName = "happi";
  networking.useDHCP = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8096 ];
    trustedInterfaces = [ "tailscale0" ];
    checkReversePath = "loose";
  };
}
