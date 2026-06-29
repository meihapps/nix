{ ... }:
{
  networking.hostName = "happi";
  networking.useDHCP = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 5030 8096 8686 9696 50300 ];
    trustedInterfaces = [ "tailscale0" ];
    checkReversePath = "loose";
  };
}
