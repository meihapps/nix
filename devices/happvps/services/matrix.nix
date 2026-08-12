{ config, lib, ... }:
{
  services.matrix-continuwuity = {
    enable = true;
    group = "caddy";
    settings.global = {
      server_name = "meihapps.gay";

      address = null;
      unix_socket_path = "/run/continuwuity/continuwuity.sock";
      unix_socket_perms = 660;

      well_known = {
        client = "https://matrix.meihapps.gay";
        server = "matrix.meihapps.gay:443";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /mnt/data/continuwuity 0700 root root - -"
  ];

  fileSystems."/var/lib/private/continuwuity" = {
    device = "/mnt/data/continuwuity";
    fsType = "none";
    options = [ "bind" ];
  };

  systemd.services.continuwuity.unitConfig.RequiresMountsFor = "/mnt/data";

  services.caddy.virtualHosts = {
    "matrix.meihapps.gay".extraConfig = ''
      reverse_proxy unix//run/continuwuity/continuwuity.sock
    '';

    "meihapps.gay".extraConfig = lib.mkBefore ''
      handle /.well-known/matrix/* {
        reverse_proxy unix//run/continuwuity/continuwuity.sock
      }
    '';
  };
}
