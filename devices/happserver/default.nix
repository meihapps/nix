{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./services
    ./storage.nix
    ../../modules/environment
  ];
}
