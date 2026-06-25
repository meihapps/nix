{ ... }:
{
  networking = {
    hostName = "happtop";
    networkmanager.enable = true;
  };

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    checkReversePath = "loose";
  };
}
