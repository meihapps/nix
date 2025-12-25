{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # standalone tools
    atuin
    bat
    btop
    eza
    git
    git-lfs
    hyfetch
    lazygit
    ncdu
    tealdeer
    tree
    wget
    hyfetch
    zoxide

    # dependancies
    fd
    ffmpeg
    fzf
    httpie
    jq
    poppler
    resvg
    ripgrep
  ];
}
