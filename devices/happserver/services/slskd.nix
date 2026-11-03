{ config, lib, ... }:
{
  age.secrets.slskd-config = {
    file = ../../../secrets/slskd-config.age;
    owner = "slskd";
  };

  services.slskd = {
    enable = true;
    group = "media";
    domain = null;
    # Required by the module, but credentials live in the slskd-config secret.
    environmentFile = "/dev/null";
    settings = {
      flags.force_share_scan = false;
      # These must match the paths in the slskd-config secret.
      directories.downloads = "/mnt/storage/downloads";
      shares.directories = [ "/mnt/storage/music" ];
    };
  };

  # The module's generated config is replaced by the secret, so `settings` above
  # only affects the service's sandbox.
  systemd.services.slskd = {
    serviceConfig.ExecStart = lib.mkForce "${config.services.slskd.package}/bin/slskd --app-dir /var/lib/slskd --config ${config.age.secrets.slskd-config.path}";
    serviceConfig.UMask = "0002";
    unitConfig.RequiresMountsFor = "/mnt/storage";
  };

  services.caddy.virtualHosts."slskd.meihapps.gay".extraConfig = ''
    import tailnet
    reverse_proxy 127.0.0.1:5030
  '';
}
