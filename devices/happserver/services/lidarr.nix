{ ... }:
{
  services.lidarr = {
    enable = true;
    group = "media";
  };

  systemd.services.lidarr = {
    unitConfig.RequiresMountsFor = "/mnt/storage";
    serviceConfig.UMask = "0002";
  };

  services.caddy.virtualHosts."lidarr.meihapps.gay".extraConfig = ''
    import tailnet
    reverse_proxy 127.0.0.1:8686
  '';
}
