{ config, pkgs, ... }:
let
  dataDir = "${config.home.homeDirectory}/.config/Lidarr";
in
{
  systemd.user.tmpfiles.rules = [
    "d ${dataDir} 0755 - - -"
  ];

  systemd.user.services.lidarr = {
    Unit = {
      Description = "Lidarr";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.lidarr}/bin/Lidarr -nobrowser -data=${dataDir}";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
