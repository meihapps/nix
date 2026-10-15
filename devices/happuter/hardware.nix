{ pkgs, ... }:
{
  fileSystems."/mnt/happssd" = {
    device = "/dev/disk/by-uuid/a181f2d7-2b6a-4c1b-a0b9-979b1896124a";
    fsType = "ext4";
    options = [ "nofail" "x-systemd.device-timeout=30" ];
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Privacy = "device";
          JustWorksRepairing = "always";
          Class = "0x000100";
          FastConnectable = "true";
        };
      };
    };
    xpadneo.enable = true;
  };

  chaotic.nyx.cache.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  services = {
    blueman.enable = true;
    ratbagd.enable = true;
    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", MODE="0666", TAG+="uaccess"
    '';
  };
}
