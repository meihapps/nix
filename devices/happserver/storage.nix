{ config, pkgs, ... }:
{
  system.fsPackages = [ pkgs.mergerfs ];

  users.users.mei.extraGroups = [ "media" ];

  fileSystems."/mnt/storage0" = {
    device = "/dev/disk/by-uuid/FF11-526C";
    fsType = "exfat";
    # exFAT has no owners or modes, so they're set for the whole drive here.
    # No boot-time fsck: it flags filenames that a repair would rename.
    noCheck = true;
    options = [
      "nofail"
      "noatime"
      "uid=1000"
      "gid=${toString config.users.groups.media.gid}"
      "dmask=0002"
      "fmask=0113"
    ];
  };

  fileSystems."/mnt/storage1" = {
    device = "/dev/disk/by-uuid/876fdaa9-ab70-4421-8922-62fd99f61d0f";
    fsType = "ext4";
    options = [ "nofail" "noatime" ];
  };

  fileSystems."/mnt/storage" = {
    device = "/mnt/storage0:/mnt/storage1";
    fsType = "fuse.mergerfs";
    depends = [ "/mnt/storage0" "/mnt/storage1" ];
    options = [
      "nofail"
      "fsname=storage"
      # Most free space, not the default existing-path policy, which would keep
      # sending new files in existing folders to the nearly full 8TB drive.
      "category.create=mfs"
      "minfreespace=50G"
      "moveonenospc=true"
      "dropcacheonclose=true"
      "func.getattr=newest"
      "cache.files=off"
    ];
  };
}
