{ pkgs, ... }:

{
  home.packages = with pkgs; [
    helix
    marksman
    ghostty-bin
    vscodium
    zed-editor
  ];
}
