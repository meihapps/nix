{ pkgs, ... }:
{
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    helix
    firefox
  ];

  fonts.packages = with pkgs; [
    fira-code
    nerd-fonts.fira-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
