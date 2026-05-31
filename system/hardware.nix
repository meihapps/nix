{ config, pkgs, ... }:
let
  rtl88x2bu = pkgs.callPackage ./rtl88x2bu.nix {
    kernel = config.boot.kernelPackages.kernel;
  };
in
{
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
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.blueman.enable = true;

  powerManagement.cpuFreqGovernor = "performance";
}
