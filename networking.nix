{ ... }:
{
  networking = {
    hostName = "happuter";
    networkmanager.enable = true;
    programs.ssh.startAgent = true;
    # services.openssh.enable = true; for using ssh to access this machine
  };
}
