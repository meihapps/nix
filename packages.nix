{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    helix
    firefox
  ];

  fonts.packages = with pkgs; [
    fira-code
  ];
}
