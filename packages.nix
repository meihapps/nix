{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    helix
  ];

  fonts.packages = with pkgs; [
    fira-code
  ];
}
