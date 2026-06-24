{ config, pkgs, ... }:
let
  configTemplate = pkgs.writeText "lidarr-config.xml" ''
    <Config>
      <BindAddress>*</BindAddress>
      <Port>8686</Port>
      <SslPort>6868</SslPort>
      <EnableSsl>False</EnableSsl>
      <LaunchBrowser>False</LaunchBrowser>
      <AuthenticationMethod>External</AuthenticationMethod>
      <AuthenticationType>DisabledForLocalAddresses</AuthenticationType>
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
      "/mnt/happssd/media:/data"
    ];
    extraOptions = [ "--network=services" ];
  };

  # Fix settings migrated from the Arch install that reference host paths or localhost.
  # All updates are idempotent — no-ops once the DB is already correct.
  systemd.services.lidarr-migration-fix = {
    description = "Fix Lidarr DB settings migrated from Arch install";
    wantedBy = [ "multi-user.target" ];
    before = [ "docker-lidarr.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "lidarr-migration-fix" ''
        [ -f /var/lib/lidarr/lidarr.db ] || exit 0
        db=/var/lib/lidarr/lidarr.db
        ${pkgs.sqlite}/bin/sqlite3 "$db" "
          UPDATE DownloadClients
            SET Settings = json_set(Settings, '$.host', 'qbittorrent')
            WHERE Implementation = 'QBittorrent'
              AND json_extract(Settings, '$.host') != 'qbittorrent';
          UPDATE RootFolders
            SET Path = replace(Path, '/mnt/happssd/media/', '/data/')
            WHERE Path LIKE '/mnt/happssd/media/%';
          UPDATE RootFolders
            SET Path = replace(Path, '/data/media/', '/data/')
            WHERE Path LIKE '/data/media/%';
          UPDATE Indexers
            SET Settings = replace(Settings, 'http://localhost:9696/', 'http://prowlarr:9696/')
            WHERE Settings LIKE '%http://localhost:9696/%';
          UPDATE Artists
            SET Path = replace(Path, '/mnt/happssd/media/', '/data/')
            WHERE Path LIKE '/mnt/happssd/media/%';
          UPDATE Artists
            SET Path = replace(Path, '/data/media/', '/data/')
            WHERE Path LIKE '/data/media/%';
          UPDATE TrackFiles
            SET Path = replace(Path, '/mnt/happssd/media/', '/data/')
            WHERE Path LIKE '/mnt/happssd/media/%';
          UPDATE TrackFiles
            SET Path = replace(Path, '/data/media/', '/data/')
            WHERE Path LIKE '/data/media/%';
          UPDATE RemotePathMappings
            SET Host = 'qbittorrent', RemotePath = '/downloads/', LocalPath = '/data/downloads/'
            WHERE Host IN ('10.0.0.2', 'qbittorrent') AND LocalPath != '/data/downloads/';
          UPDATE IndexerStatus SET DisabledTill = NULL;
          UPDATE DownloadClientStatus SET DisabledTill = NULL;
        "
      '';
    };
  };

  systemd.services."docker-lidarr" = {
    requires = [ "docker-network-services.service" "mnt-happssd.mount" ];
    after = [ "docker-network-services.service" "mnt-happssd.mount" "lidarr-migration-fix.service" ];
    wants = [ "lidarr-migration-fix.service" ];
  };

  happuter.caddy.virtualHosts."lidarr.meihapps.gay" = "reverse_proxy lidarr:8686";
}
