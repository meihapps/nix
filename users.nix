{ pkgs, ... }:
{
  users.users.mei = {
    isNormalUser = true;
    extraGroups = [ "audio" "network-manager" "video" "wheel" ];
  };

  services.getty.autologinUser = "mei";
}
