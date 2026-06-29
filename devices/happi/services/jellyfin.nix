{ config, pkgs, ... }:
let
  dataDir = "${config.home.homeDirectory}/.local/share/jellyfin";
in
{
  systemd.user.tmpfiles.rules = [
    "d ${dataDir} 0755 - - -"
  ];

  systemd.user.services.jellyfin = {
    Unit = {
      Description = "Jellyfin Media Server";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.jellyfin}/bin/jellyfin --datadir ${dataDir}";
      Restart = "on-failure";
      Environment = [ "HOME=${config.home.homeDirectory}" ];
    };
    Install.WantedBy = [ "default.target" ];
  };
}
