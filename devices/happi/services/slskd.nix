{ config, pkgs, ... }:
let
  configDir = "${config.home.homeDirectory}/.local/share/slskd";
in
{
  systemd.user.tmpfiles.rules = [
    "d ${configDir} 0755 - - -"
  ];

  systemd.user.services.slskd = {
    Unit = {
      Description = "slskd Soulseek client";
      After = [ "network.target" "mnt-media.mount" ];
      Requires = [ "mnt-media.mount" ];
    };
    Service = {
      ExecStart = "${pkgs.slskd}/bin/slskd --app-dir ${configDir}";
      Restart = "on-failure";
      WorkingDirectory = configDir;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
