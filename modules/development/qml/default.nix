{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    qmlls
  ];
}
