{ lib, ... }:
{
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.raspberry-pi.bootloader = lib.mkForce "kernel";
}
