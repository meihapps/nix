{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.loader = {
    efi.efiSysMountPoint = "/boot/efi";
    grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };
  fileSystems = {
    "/boot/efi" = {
      device = "/dev/disk/by-uuid/BBF7-A736";
      fsType = "vfat";
    };
    "/mnt/data" = {
      device = "/dev/disk/by-uuid/d09bb755-12d0-46a2-a1fd-6b9ba08ada13";
      fsType = "ext4";
    };
  };
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/mapper/ocivolume-root"; fsType = "xfs"; };

}
