{ config, pkgs, ... }:
let
  dataDir = "${config.home.homeDirectory}/.config/Prowlarr";
in
{
  systemd.user.tmpfiles.rules = [
    "d ${dataDir} 0755 - - -"
  ];

  systemd.user.services.prowlarr = {
    Unit = {
      Description = "Prowlarr";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.prowlarr}/bin/Prowlarr -nobrowser -data=${dataDir}";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
