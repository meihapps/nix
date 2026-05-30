{ pkgs, ... }:
{
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    helix
    firefox
  ];

  fonts.packages = with pkgs; [
    fira-code
  ];
}
