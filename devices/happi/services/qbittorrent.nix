{ config, pkgs, ... }:
{
  systemd.user.tmpfiles.rules = [
    "d ${config.home.homeDirectory}/.config/qBittorrent 0755 - - -"
  ];

  systemd.user.services.qbittorrent = {
    Unit = {
      Description = "qBittorrent-nox";
      After = [ "network-online.target" "mnt-media.mount" ];
      Requires = [ "mnt-media.mount" ];
    };
    Service = {
      ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox";
      Restart = "on-failure";
      Environment = [
        "XDG_CONFIG_HOME=${config.home.homeDirectory}/.config"
      ];
    };
    Install.WantedBy = [ "default.target" ];
  };
}
