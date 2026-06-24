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
  i18n.defaultLocale = "en_GB.UTF-8";
}
