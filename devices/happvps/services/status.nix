{ pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /var/www/status.meihapps.gay 0755 caddy caddy -"
  ];

  systemd.services.status-deploy = {
    description = "Clone/update happnet-status";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "caddy";
      ExecStart = pkgs.writeShellScript "status-deploy" ''
        export PATH="${pkgs.git}/bin:${pkgs.git-lfs}/bin:$PATH"
        if [ ! -d /var/www/status.meihapps.gay/.git ]; then
          git clone https://github.com/meihapps/happnet-status.git /var/www/status.meihapps.gay
        else
          git -C /var/www/status.meihapps.gay pull --ff-only
          (cd /var/www/status.meihapps.gay && git lfs pull)
        fi
      '';
    };
  };

  systemd.timers.status-deploy = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "0";
      OnUnitActiveSec = "5m";
    };
  };

  services.phpfpm.pools.status = {
    user = "caddy";
    settings = {
      "listen.owner" = "caddy";
      "pm" = "dynamic";
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
    };
  };

  services.caddy.virtualHosts."status.meihapps.gay".extraConfig = ''
    root * /var/www/status.meihapps.gay
    php_fastcgi unix//run/phpfpm/status.sock
    encode gzip
    file_server
  '';
}
