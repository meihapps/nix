{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    comma
    eza
    fd
    ripgrep
    zoxide
    taskwarrior3
    wireguard-tools
    (callPackage ./catnap.nix {})
  ];
}
