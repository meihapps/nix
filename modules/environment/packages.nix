{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    eza
    fd
    ripgrep
    zoxide
    (callPackage ../catnap.nix {})
  ];
}
