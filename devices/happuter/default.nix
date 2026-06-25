{ inputs, remoteHosts, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./audio.nix
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./packages.nix
    ./vpn.nix
    ./services
    ./users.nix
    ../../modules/environment
    ../../modules/desktop
    ../../modules/development
  ];

  home-manager.extraSpecialArgs = { inherit remoteHosts; };
  home-manager.users.mei.imports = [ ./shell.nix ];

  nix.settings.build-dir = "/mnt/happssd/nix-builds";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
