{ config, pkgs, ... }:
let
  gostImage = pkgs.dockerTools.buildImage {
    name = "gost-relay";
    tag = "local";
    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      paths = [ pkgs.gost pkgs.bash pkgs.coreutils ];
      pathsToLink = [ "/bin" ];
    };
    config.Entrypoint = [
      "/bin/bash" "-c"
      "exec /bin/gost -L socks5://:1080 -F \"$(cat /run/secrets/upstream)\""
    ];
  };
in
{
  age.secrets.socks5-proxy.file = ../../secrets/socks5-proxy.age;

  virtualisation.oci-containers.containers.gost = {
    image = "gost-relay:local";
    imageFile = gostImage;
    volumes = [ "${config.age.secrets.socks5-proxy.path}:/run/secrets/upstream:ro" ];
    extraOptions = [ "--network=services" ];
  };

  systemd.services."docker-gost" = {
    requires = [ "docker-network-services.service" ];
    after = [ "docker-network-services.service" ];
  };
}
