{ pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /var/www/meihapps.gay 0755 caddy caddy -"
  ];

  systemd.services.website-deploy = {
    description = "Clone/update meihapps.gay website";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
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

  services.phpfpm.pools.meihapps = {
    user = "caddy";
    settings = {
      "listen.owner" = "caddy";
      "pm" = "dynamic";
      "pm.max_children" = "5";
      "pm.start_servers" = "2";
      "pm.min_spare_servers" = "1";
      "pm.max_spare_servers" = "3";
    };
  };

  services.caddy.virtualHosts."meihapps.gay" = {
    extraConfig = ''
      root * /var/www/meihapps.gay
      encode gzip
      php_fastcgi unix//run/phpfpm/meihapps.sock
      file_server
    '';
  };

  systemd.services.caddy.after = [ "website-deploy.service" ];
  systemd.services.caddy.requires = [ "website-deploy.service" ];
  systemd.services.phpfpm-meihapps.after = [ "website-deploy.service" ];
  systemd.services.phpfpm-meihapps.requires = [ "website-deploy.service" ];
}
