{ ... }:
{
  imports = [
    ../hardware-configuration.nix
    ./boot.nix
    ./desktop.nix
    ./hardware.nix
    ./home-manager.nix
    ./networking.nix
    ./nix.nix
    ./vpn.nix
    ./packages.nix
    ./services
    ./users.nix
  ];
}
