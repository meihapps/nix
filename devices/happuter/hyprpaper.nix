{ lib, ... }:
{
  xdg.configFile."hypr/background.png".source = lib.mkForce ./background_5120x2160.png;
}
