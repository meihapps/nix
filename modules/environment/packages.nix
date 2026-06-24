{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    comma
    eza
    fd
    ripgrep
    zoxide
    (callPackage ../catnap.nix {})
  ];
}
