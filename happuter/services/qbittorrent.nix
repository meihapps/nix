{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /var/lib/qbittorrent 0755 root root -"
  ];

  virtualisation.oci-containers.containers.qbittorrent = {
    image = "lscr.io/linuxserver/qbittorrent:latest";
    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "Europe/London";
      WEBUI_PORT = "8080";
    };
    # Port 6881 must be reachable from the internet for peers to connect.
    ports = [
      "6881:6881"
      "6881:6881/udp"
    ];
    volumes = [
      "/var/lib/qbittorrent:/config"
      "/mnt/happssd/media/downloads:/downloads"
    ];
    extraOptions = [ "--network=services" "--ip=172.20.0.200" ];
  };

  systemd.services."docker-qbittorrent" = {
    requires = [ "docker-network-services.service" "mnt-happssd.mount" "services-policy-routing.service" ];
    after = [ "docker-network-services.service" "services-policy-routing.service" "mnt-happssd.mount" ];
  };

  happuter.caddy.virtualHosts."qbittorrent.meihapps.gay" = "reverse_proxy qbittorrent:8080";
}
