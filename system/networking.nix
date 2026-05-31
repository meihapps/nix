{ ... }:
{
  networking = {
    hostName = "happuter";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  networking.firewall.enable = true;

  programs.ssh.startAgent = true;
}
