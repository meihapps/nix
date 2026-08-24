{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kdePackages.qtdeclarative
  ];

  qt.enable = true;
}
