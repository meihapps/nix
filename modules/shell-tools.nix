{ pkgs, ... }:

{
  home.packages = with pkgs; [
    atuin
    bat
    btop
    eza
    fd
    fzf
    git
    git-lfs
    httpie
    jq
    lazygit
    ncdu
    ripgrep
    tealdeer
    tree
    wget
    hyfetch
    zoxide
  ];
}
