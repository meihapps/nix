{ ... }:
{
  services.jellyfin = {
    enable = true;
    group = "media";
  };

  # Stays stopped until the NAS is mounted, so it can't start with an empty library.
  systemd.services.jellyfin.unitConfig.RequiresMountsFor = "/mnt/storage";

  services.caddy.virtualHosts."jellyfin.meihapps.gay" = {
    serverAliases = [ "dolphish.hellixyashellhole.net" ];
    extraConfig = ''
      reverse_proxy 127.0.0.1:8096
    '';
  };
}
