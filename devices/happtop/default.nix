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

  hardware.bluetooth.enable = true;
  services.upower.enable = true;

  home-manager.users.mei.imports = [ ./hyprland.nix ./hyprlock.nix ];
}
