{ ... }:
{
  boot.initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
  nixpkgs.hostPlatform = "aarch64-linux";
}
