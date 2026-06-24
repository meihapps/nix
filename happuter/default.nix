{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./graphical.nix
    ./hardware.nix
    ./home-manager.nix
    ./networking.nix
    ./packages.nix
    ./vpn.nix
    ./services
    ./users.nix
    ../modules/system
  ];

  nix.settings.build-dir = "/mnt/happssd/nix-builds";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  system.stateVersion = "26.05";
}
