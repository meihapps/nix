{ pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /var/www/meihapps.gay 0755 caddy caddy -"
  ];

  systemd.services.website-deploy = {
    description = "Clone/update meihapps.gay website";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "caddy";
      ExecStart = pkgs.writeShellScript "website-deploy" ''
        export PATH="${pkgs.git}/bin:${pkgs.git-lfs}/bin:$PATH"
        if [ ! -d /var/www/meihapps.gay/.git ]; then
          git clone https://github.com/meihapps/website.git /var/www/meihapps.gay
        else
          git -C /var/www/meihapps.gay pull --ff-only
          (cd /var/www/meihapps.gay && git lfs pull)
        fi
      '';
    };
  };

  systemd.timers.website-deploy = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "0";
      OnUnitActiveSec = "5m";
    };
  };

  services.caddy.virtualHosts."meihapps.gay" = {
    extraConfig = ''
      root * /var/www/meihapps.gay
      encode gzip
      file_server
    '';
  };

  systemd.services.caddy.after = [ "website-deploy.service" ];
  systemd.services.caddy.requires = [ "website-deploy.service" ];
}
