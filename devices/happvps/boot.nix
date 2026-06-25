{ pkgs, lib, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # OCI VMs can't persist EFI NVRAM entries — firmware always boots from the
  # removable fallback path \EFI\BOOT\BOOTAA64.EFI. Grub with efiInstallAsRemovable
  # handles this correctly; systemd-boot does not.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
}
