{ ... }:
{
  services.qbittorrent = {
    enable = true;
    group = "media";
  };

  systemd.services.qbittorrent = {
    unitConfig.RequiresMountsFor = "/mnt/storage";
    serviceConfig.UMask = "0002";
  };

  services.caddy.virtualHosts."qbittorrent.meihapps.gay".extraConfig = ''
    import tailnet
    reverse_proxy 127.0.0.1:8080
  '';
}
