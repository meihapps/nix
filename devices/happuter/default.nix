{ inputs, remoteHosts, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./audio.nix
    ./flatpak.nix
    ./hardware.nix
    ./local.nix
    ./networking.nix
    ./packages.nix
    ./rgb.nix
    ./vpn.nix
    ./users.nix
    ../../modules/environment
    ../../modules/desktop
    ../../modules/development
  ];

  home-manager.extraSpecialArgs = { inherit inputs remoteHosts; };
  home-manager.users.mei.imports = [
    ./shell.nix
    ./sine.nix
    { programs.umbriel.settings.output.DP-1.scale = 2; }
  ];

  nix.settings.build-dir = "/mnt/happssd/nix-builds";
}
