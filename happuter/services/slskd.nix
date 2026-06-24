{ config, ... }:
{
  age.secrets.slskd-config = {
    file = ../../secrets/slskd-config.age;
    mode = "0444";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/slskd 0755 root root -"
  ];

  virtualisation.oci-containers.containers.slskd = {
    image = "slskd/slskd:latest";
    environment = {
      TZ = "Europe/London";
    };
    volumes = [
      "/var/lib/slskd:/app"
      "${config.age.secrets.slskd-config.path}:/app/slskd.yml:ro"
      "/mnt/happssd:/music"
    ];
    extraOptions = [ "--network=services" ];
  };

  systemd.services."docker-slskd" = {
    requires = [ "docker-network-services.service" "mnt-happssd.mount" ];
    after = [ "docker-network-services.service" "mnt-happssd.mount" ];
  };

  happuter.caddy.virtualHosts."slskd.meihapps.gay" = "reverse_proxy slskd:5030";
}
