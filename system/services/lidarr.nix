{ config, pkgs, ... }:
let
  configTemplate = pkgs.writeText "lidarr-config.xml" ''
    <Config>
      <BindAddress>*</BindAddress>
      <Port>8686</Port>
      <SslPort>6868</SslPort>
      <EnableSsl>False</EnableSsl>
      <LaunchBrowser>False</LaunchBrowser>
      <AuthenticationMethod>Forms</AuthenticationMethod>
      <AuthenticationRequired>DisabledForLocalAddresses</AuthenticationRequired>
      <Branch>master</Branch>
      <LogLevel>info</LogLevel>
      <UrlBase></UrlBase>
      <InstanceName>Lidarr</InstanceName>
      <UpdateMechanism>External</UpdateMechanism>
    </Config>
  '';
in
{
  age.secrets.lidarr-api-key.file = ../../secrets/lidarr-api-key.age;

  # PUID/PGID match the existing lidarr user (uid=954) on the Arch install.
  systemd.tmpfiles.rules = [ "d /var/lib/lidarr 0755 - - -" ];

  systemd.services.lidarr-config-init = {
    description = "Initialise Lidarr config with API key";
    wantedBy = [ "multi-user.target" ];
    before = [ "docker-lidarr.service" ];
    unitConfig.ConditionPathExists = "!/var/lib/lidarr/config.xml";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "lidarr-config-init" ''
        mkdir -p /var/lib/lidarr
        ${pkgs.gnused}/bin/sed \
          "s|</Config>|  <ApiKey>$(cat ${config.age.secrets.lidarr-api-key.path})</ApiKey>\n</Config>|" \
          ${configTemplate} > /var/lib/lidarr/config.xml
      '';
    };
  };

  virtualisation.oci-containers.containers.lidarr = {
    image = "lscr.io/linuxserver/lidarr:latest";
    environment = {
      PUID = "954";
      PGID = "954";
      TZ = "Europe/London";
    };
    volumes = [
      "/var/lib/lidarr:/config"
      "/mnt/happssd:/data"
    ];
    extraOptions = [ "--network=services" ];
  };

  systemd.services."docker-lidarr" = {
    requires = [ "docker-network-services.service" ];
    after = [ "docker-network-services.service" ];
  };
}
