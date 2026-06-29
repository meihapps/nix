{ ... }:
{
  services.flaresolverr.enable = true;

  services.caddy.virtualHosts."flaresolverr.meihapps.gay".extraConfig = ''
    reverse_proxy 127.0.0.1:8191
  '';
}
