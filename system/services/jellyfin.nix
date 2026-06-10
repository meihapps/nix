{ pkgs, ... }:
let
  systemXml = pkgs.writeText "jellyfin-system.xml" ''
    <?xml version="1.0" encoding="utf-8"?>
    <ServerConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <LogFileRetentionDays>3</LogFileRetentionDays>
      <IsStartupWizardCompleted>false</IsStartupWizardCompleted>
      <EnableMetrics>false</EnableMetrics>
      <EnableNormalizedItemByNameIds>true</EnableNormalizedItemByNameIds>
      <IsPortAuthorized>true</IsPortAuthorized>
      <QuickConnectAvailable>true</QuickConnectAvailable>
      <EnableCaseSensitiveItemIds>true</EnableCaseSensitiveItemIds>
      <DisableLiveTvChannelUserDataName>true</DisableLiveTvChannelUserDataName>
      <MetadataPath />
      <PreferredMetadataLanguage>en</PreferredMetadataLanguage>
      <MetadataCountryCode>US</MetadataCountryCode>
      <SortReplaceCharacters>
        <string>.</string>
        <string>+</string>
        <string>%</string>
      </SortReplaceCharacters>
      <SortRemoveCharacters>
        <string>,</string>
        <string>&amp;</string>
        <string>-</string>
        <string>{</string>
        <string>}</string>
        <string>'</string>
      </SortRemoveCharacters>
      <SortRemoveWords>
        <string>the</string>
        <string>a</string>
        <string>an</string>
      </SortRemoveWords>
      <MinResumePct>5</MinResumePct>
      <MaxResumePct>90</MaxResumePct>
      <MinResumeDurationSeconds>300</MinResumeDurationSeconds>
      <MinAudiobookResume>5</MinAudiobookResume>
      <MaxAudiobookResume>5</MaxAudiobookResume>
      <LibraryMonitorDelay>60</LibraryMonitorDelay>
      <LibraryUpdateDuration>30</LibraryUpdateDuration>
      <ImageSavingConvention>Legacy</ImageSavingConvention>
      <ServerName>happuter</ServerName>
      <UICulture>en-US</UICulture>
      <EnableExternalContentInSuggestions>true</EnableExternalContentInSuggestions>
      <CorsHosts>
        <string>*</string>
      </CorsHosts>
      <ActivityLogRetentionDays>30</ActivityLogRetentionDays>
      <EnableLegacyAuthorization>true</EnableLegacyAuthorization>
      <PluginRepositories>
        <RepositoryInfo>
          <Name>Jellyfin Stable</Name>
          <Url>https://repo.jellyfin.org/files/plugin/manifest.json</Url>
          <Enabled>true</Enabled>
        </RepositoryInfo>
        <RepositoryInfo>
          <Name>Last.fm Stable</Name>
          <Url>https://raw.githubusercontent.com/danielfariati/jellyfin-plugin-lastfm/refs/heads/master/manifest.json</Url>
          <Enabled>true</Enabled>
        </RepositoryInfo>
      </PluginRepositories>
    </ServerConfiguration>
  '';

  networkXml = pkgs.writeText "jellyfin-network.xml" ''
    <?xml version="1.0" encoding="utf-8"?>
    <NetworkConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <BaseUrl />
      <EnableHttps>false</EnableHttps>
      <RequireHttps>false</RequireHttps>
      <InternalHttpPort>8096</InternalHttpPort>
      <InternalHttpsPort>8920</InternalHttpsPort>
      <PublicHttpPort>8096</PublicHttpPort>
      <PublicHttpsPort>8920</PublicHttpsPort>
      <AutoDiscovery>true</AutoDiscovery>
      <EnableIPv4>true</EnableIPv4>
      <EnableIPv6>false</EnableIPv6>
      <EnableRemoteAccess>true</EnableRemoteAccess>
      <KnownProxies />
      <IgnoreVirtualInterfaces>false</IgnoreVirtualInterfaces>
      <EnablePublishedServerUriByRequest>false</EnablePublishedServerUriByRequest>
    </NetworkConfiguration>
  '';

  encodingXml = pkgs.writeText "jellyfin-encoding.xml" ''
    <?xml version="1.0" encoding="utf-8"?>
    <EncodingOptions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <EncodingThreadCount>-1</EncodingThreadCount>
      <EnableFallbackFont>false</EnableFallbackFont>
      <EnableAudioVbr>false</EnableAudioVbr>
      <DownMixAudioBoost>2</DownMixAudioBoost>
      <DownMixStereoAlgorithm>None</DownMixStereoAlgorithm>
      <MaxMuxingQueueSize>2048</MaxMuxingQueueSize>
      <EnableThrottling>false</EnableThrottling>
      <ThrottleDelaySeconds>180</ThrottleDelaySeconds>
      <HardwareAccelerationType>none</HardwareAccelerationType>
      <VaapiDevice>/dev/dri/renderD128</VaapiDevice>
      <EnableTonemapping>false</EnableTonemapping>
      <TonemappingAlgorithm>bt2390</TonemappingAlgorithm>
      <TonemappingMode>auto</TonemappingMode>
      <TonemappingRange>auto</TonemappingRange>
      <H264Crf>23</H264Crf>
      <H265Crf>28</H265Crf>
      <DeinterlaceMethod>yadif</DeinterlaceMethod>
      <EnableDecodingColorDepth10Hevc>true</EnableDecodingColorDepth10Hevc>
      <EnableDecodingColorDepth10Vp9>true</EnableDecodingColorDepth10Vp9>
      <EnableEnhancedNvdecDecoder>true</EnableEnhancedNvdecDecoder>
      <PreferSystemNativeHwDecoder>true</PreferSystemNativeHwDecoder>
      <EnableHardwareEncoding>true</EnableHardwareEncoding>
      <AllowHevcEncoding>false</AllowHevcEncoding>
      <AllowAv1Encoding>false</AllowAv1Encoding>
      <EnableSubtitleExtraction>true</EnableSubtitleExtraction>
      <HardwareDecodingCodecs>
        <string>h264</string>
        <string>vc1</string>
      </HardwareDecodingCodecs>
      <AllowOnDemandMetadataBasedKeyframeExtractionForExtensions>
        <string>mkv</string>
      </AllowOnDemandMetadataBasedKeyframeExtractionForExtensions>
    </EncodingOptions>
  '';

  loggingJson = pkgs.writeText "jellyfin-logging.json" ''
    {
        "Serilog": {
            "MinimumLevel": {
                "Default": "Information",
                "Override": {
                    "Microsoft": "Warning",
                    "System": "Warning"
                }
            },
            "WriteTo": [
                {
                    "Name": "Console",
                    "Args": {
                        "outputTemplate": "[{Timestamp:HH:mm:ss}] [{Level:u3}] [{ThreadId}] {SourceContext}: {Message:lj}{NewLine}{Exception}"
                    }
                },
                {
                    "Name": "Async",
                    "Args": {
                        "configure": [
                            {
                                "Name": "File",
                                "Args": {
                                    "path": "%JELLYFIN_LOG_DIR%//log_.log",
                                    "rollingInterval": "Day",
                                    "retainedFileCountLimit": 3,
                                    "rollOnFileSizeLimit": true,
                                    "fileSizeLimitBytes": 100000000,
                                    "outputTemplate": "[{Timestamp:yyyy-MM-dd HH:mm:ss.fff zzz}] [{Level:u3}] [{ThreadId}] {SourceContext}: {Message}{NewLine}{Exception}"
                                }
                            }
                        ]
                    }
                }
            ],
            "Enrich": [ "FromLogContext", "WithThreadId" ]
        }
    }
  '';
in
{
  # PUID/PGID match the existing jellyfin user (uid=952) on the Arch install.
  # The linuxserver image expects config files under /config/config/ inside the container.
  systemd.tmpfiles.rules = [
    "d /var/lib/jellyfin 0755 - - -"
    "d /var/lib/jellyfin/config 0755 - - -"
    "C /var/lib/jellyfin/config/system.xml          - - - - ${systemXml}"
    "C /var/lib/jellyfin/config/network.xml         - - - - ${networkXml}"
    "C /var/lib/jellyfin/config/encoding.xml        - - - - ${encodingXml}"
    "C /var/lib/jellyfin/config/logging.default.json - - - - ${loggingJson}"
  ];

  virtualisation.oci-containers.containers.jellyfin = {
    image = "lscr.io/linuxserver/jellyfin:latest";
    environment = {
      PUID = "952";
      PGID = "952";
      TZ = "Europe/London";
    };
    volumes = [
      "/var/lib/jellyfin:/config"
      "/mnt/happssd:/data:ro"
    ];
    extraOptions = [ "--network=services" ];
  };

  systemd.services."docker-jellyfin" = {
    requires = [ "docker-network-services.service" "mnt-happssd.mount" ];
    after = [ "docker-network-services.service" "mnt-happssd.mount" ];
  };
}
