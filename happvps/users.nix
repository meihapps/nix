{ pkgs, ... }:
{
  programs.fish.enable = true;

  users.users.mei = {
    isNormalUser = true;
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvBaUH/v9Te7eFbAjyNpTVjuyP7h8fcsErmwUUxgyEZ meihapps@happtop.local"
    ];
  };

  users.users.root = {
    hashedPassword = "$6$l42mduZihI/qNnGf$DH8ivw.Qb.B7MVlyWL2uVnY4UmiLCf7tk2fUOrFtvTQVz8d1FmO/caC8X3vYEOtnqg.aixGpnmajZdmid3tQx1";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvBaUH/v9Te7eFbAjyNpTVjuyP7h8fcsErmwUUxgyEZ meihapps@happtop.local"
    ];
  };

  security.sudo.wheelNeedsPassword = false;
}
