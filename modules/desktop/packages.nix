{ inputs, pkgs, ... }:
{
  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 32;
    gtk.enable = true;
    hyprcursor.enable = true;
  };

  home.packages = with pkgs; [
    inputs.quickshell.packages.${stdenv.hostPlatform.system}.default

    ashell
    brightnessctl
    cliphist
    ddcutil
    hyprshot
    hyprpaper
    hyprlock
    libnotify
    piper
    playerctl
    steam
    thunar
    thunderbird
    vesktop
    wdisplays
    wl-clipboard
    wtype
  ];
}
