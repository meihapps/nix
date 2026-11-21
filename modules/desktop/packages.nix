{ inputs, pkgs, ... }:
{
  home = {
    pointerCursor = {
      enable = true;
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 32;
      gtk.enable = true;
    };

    packages = with pkgs; [
      brightnessctl
      cliphist
      ddcutil
      libnotify
      piper
      playerctl
      steam
      thunderbird
      vesktop
      wdisplays
      wl-clipboard
      wtype
    ];
  };
}
