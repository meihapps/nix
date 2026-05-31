{ pkgs, ... }:
{
  users.users.mei = {
    isNormalUser = true;
    extraGroups = [ "audio" "i2c" "network-manager" "video" "wheel" ];
    shell = pkgs.fish;
  };

  services.getty.autologinUser = "mei";
}
