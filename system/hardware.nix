{ config, pkgs, ... }:
let
  rtl88x2bu = pkgs.callPackage ./rtl88x2bu.nix {
    kernel = config.boot.kernelPackages.kernel;
  };
in
{
  fileSystems."/mnt/happssd" = {
    device = "/dev/disk/by-uuid/a181f2d7-2b6a-4c1b-a0b9-979b1896124a";
    fsType = "ext4";
    options = [ "nofail" "x-systemd.device-timeout=5" ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.enableRedistributableFirmware = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  boot = {
    extraModulePackages = [ rtl88x2bu ];
    kernelModules = [ "88x2bu" ];
    blacklistedKernelModules = [
      "rtw88_core" "rtw88_usb" "rtw88_8822bu" "rtw_8822b" "rtw88"
    ];
    kernelPatches = [{
      name = "btusb-mercusys-ma530";
      patch = ./btusb-mercusys-ma530.patch;
    }];
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/50-alsa-card-profile.conf" ''
        monitor.alsa.rules = [
          {
            matches = [{ device.name = "alsa_card.pci-0000_00_1f.3" }]
            actions = {
              update-props = {
                device.profile = "output:hdmi-stereo+input:analog-stereo"
              }
            }
          }
        ]
      '')
    ];
  };

  hardware.i2c.enable = true;

  services.ratbagd.enable = true;

  services.blueman.enable = true;

  powerManagement.cpuFreqGovernor = "performance";
}
