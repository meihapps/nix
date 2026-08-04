{ inputs, pkgs, ... }:
{
  imports = [ ./audio.nix ];

  services.gvfs.enable = true;

  services.getty.autologinUser = "mei";

  users.users.mei.extraGroups = [ "audio" "bluetooth" "i2c" "input" "networkmanager" "render" "uinput" "video" ];

  environment.systemPackages = [ pkgs.firefox ];

  fonts.packages = with pkgs; [
    fira-code
    nerd-fonts.fira-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    enableRedistributableFirmware = true;
    i2c.enable = true;
    uinput.enable = true;
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  home-manager.users.mei.imports = [
    ./bar.nix
    ./gtk.nix
    ./launcher.nix
    ./media.nix
    ./mimeapps.nix
    ./monitoring.nix
    ./notifications.nix
    ./packages.nix
    ./pdf.nix
    ./shell.nix
    ./wm
  ];
}
