{ ... }:
{
  services.prowlarr.enable = true;

  services.caddy.virtualHosts."prowlarr.meihapps.gay".extraConfig = ''
    import tailnet
    reverse_proxy 127.0.0.1:9696
  '';
}
