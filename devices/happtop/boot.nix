{ pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  boot.kernelModules = [ "uvcvideo" ];
}
