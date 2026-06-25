{ config, pkgs, ... }:
let
  configTemplate = pkgs.writeText "prowlarr-config.xml" ''
    <Config>
      <BindAddress>*</BindAddress>
      <Port>9696</Port>
      <SslPort>6969</SslPort>
      <EnableSsl>False</EnableSsl>
      <LaunchBrowser>False</LaunchBrowser>
      <AuthenticationMethod>External</AuthenticationMethod>
      <AuthenticationType>DisabledForLocalAddresses</AuthenticationType>
      <Branch>master</Branch>
      <LogLevel>info</LogLevel>
      <UrlBase></UrlBase>
      <InstanceName>Prowlarr</InstanceName>
      <UpdateMechanism>External</UpdateMechanism>
    </Config>
  '';
in
{
  age.secrets.prowlarr-api-key.file = ../../../secrets/prowlarr-api-key.age;

  systemd.tmpfiles.rules = [ "d /var/lib/prowlarr 0755 root root -" ];

  systemd.services.prowlarr-config-init = {
    description = "Initialise Prowlarr config with API key";
    wantedBy = [ "multi-user.target" ];
    before = [ "docker-prowlarr.service" ];
    unitConfig.ConditionPathExists = "!/var/lib/prowlarr/config.xml";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "prowlarr-config-init" ''
        mkdir -p /var/lib/prowlarr
        ${pkgs.gnused}/bin/sed \
          "s|</Config>|  <ApiKey>$(cat ${config.age.secrets.prowlarr-api-key.path})</ApiKey>\n</Config>|" \
          ${configTemplate} > /var/lib/prowlarr/config.xml
      '';
    };
  };

  virtualisation.oci-containers.containers.prowlarr = {
    image = "lscr.io/linuxserver/prowlarr:latest";
    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "Europe/London";
    };
    volumes = [
      "/var/lib/prowlarr:/config"
    ];
    extraOptions = [ "--network=services" ];
  };

  systemd.services."docker-prowlarr" = {
    requires = [ "docker-network-services.service" ];
    after = [ "docker-network-services.service" ];
  };

  happuter.caddy.virtualHosts."prowlarr.meihapps.gay" = "reverse_proxy prowlarr:9696";
}
