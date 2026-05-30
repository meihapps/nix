{ pkgs, ... }:
{
  users.users.mei = {
    isNormalUser = true;
    extraGroups = [ "audio" "network-manager" "video" "wheel" ];
    shell = pkgs.fish;
  };

  services.getty.autologinUser = "mei";
}
