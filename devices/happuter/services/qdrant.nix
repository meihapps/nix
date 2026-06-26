{ ... }:
{
  virtualisation.oci-containers.containers.qdrant = {
    image = "qdrant/qdrant:latest";
    volumes = [ "/var/lib/qdrant/storage:/qdrant/storage" ];
    extraOptions = [ "--network=services" ];
  };

  systemd.services."docker-qdrant" = {
    requires = [ "docker-network-services.service" ];
    after    = [ "docker-network-services.service" ];
  };
}
