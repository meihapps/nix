{ config, pkgs, ... }:
let
  dataDir = "${config.home.homeDirectory}/.local/share/caddy";
  caddyfile = pkgs.writeText "Caddyfile" ''
    jellyfin.meihapps.gay dolphish.hellixyashellhole.net {
      reverse_proxy localhost:8096
    }

    lidarr.meihapps.gay {
      reverse_proxy localhost:8686
    }

    prowlarr.meihapps.gay {
      reverse_proxy localhost:9696
    }

    slskd.meihapps.gay {
      reverse_proxy localhost:5030
    }

    qbittorrent.meihapps.gay {
      reverse_proxy localhost:8080
    }

  '';
in
{
  systemd.user.tmpfiles.rules = [
    "d ${dataDir} 0755 - - -"
  ];

  systemd.user.services.caddy = {
    Unit = {
      Description = "Caddy web server";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.caddy}/bin/caddy run --config ${caddyfile} --adapter caddyfile";
      ExecReload = "${pkgs.caddy}/bin/caddy reload --config ${caddyfile}";
      Restart = "on-failure";
      Environment = [
        "HOME=${config.home.homeDirectory}"
        "XDG_DATA_HOME=${config.home.homeDirectory}/.local/share"
      ];
    };
    Install.WantedBy = [ "default.target" ];
  };
}
