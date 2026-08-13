{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./networking.nix
    ./services
    ./users.nix
    ../../modules/environment
  ];

  nix.settings.build-dir = "/mnt/data/nix-builds";
}
