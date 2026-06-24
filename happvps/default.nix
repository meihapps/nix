{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./home-manager.nix
    ./networking.nix
    ./services
    ./users.nix
    ../modules/system
  ];

  system.stateVersion = "26.05";
}
