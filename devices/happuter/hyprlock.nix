{ lib, ... }:
{
  xdg.configFile."hypr/hyprlock-device.conf".text = lib.mkForce ''
    $inputY = -47
  '';
}
