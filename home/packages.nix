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
    claude-code
    ashell
    zoxide
    eza
    bat
    ripgrep
    fd
    ani-cli
    wireguard-tools
    taskwarrior3
    vesktop
    hyprshot
    hyprpaper
    hyprlock
    wl-clipboard
    cliphist
    playerctl
    ddcutil
    wtype
    (callPackage ../catnap.nix {})
    thunar
    piper
    python3
    uv
  ];
}
