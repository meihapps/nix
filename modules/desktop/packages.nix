{ pkgs, ... }:
{
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 32;
    gtk.enable = true;
    hyprcursor.enable = true;
  };

  home.packages = with pkgs; [
    ashell
    thunderbird
    vesktop
    hyprshot
    hyprpaper
    hyprlock
    wl-clipboard
    cliphist
    playerctl
    ddcutil
    wtype
    thunar
    piper
    brightnessctl
    wdisplays
    libnotify
  ];
}
