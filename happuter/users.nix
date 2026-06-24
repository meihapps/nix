{ pkgs, ... }:
{
  users.users.mei = {
    isNormalUser = true;
    extraGroups = [ "audio" "bluetooth" "docker" "i2c" "input" "networkmanager" "render" "video" "wheel" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvBaUH/v9Te7eFbAjyNpTVjuyP7h8fcsErmwUUxgyEZ meihapps@happtop.local"
    ];
    initialPassword = "";
  };

  services.getty.autologinUser = "mei";
  users.users.root.initialPassword = "";
}
