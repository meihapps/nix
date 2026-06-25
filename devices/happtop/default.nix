{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./networking.nix
    ./users.nix
    ../../modules/environment
    ../../modules/desktop
    ../../modules/development
  ];
}
