{ pkgs, ... }:
let
  tailscaleIP = "100.107.157.33";
in
{
  # Caddy is bound to the Tailscale IP so it's only reachable from your own
  # devices, not the public internet. The wait service below guards against
  # Docker trying to bind the port before tailscale0 has acquired its IP.
  systemd.services.wait-for-tailscale-ip = {
    description = "Wait for Tailscale IP ${tailscaleIP} to be available";
    after = [ "tailscaled.service" ];
    requires = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "wait-for-tailscale-ip" ''
        for i in $(seq 1 60); do
          if ${pkgs.iproute2}/bin/ip addr show tailscale0 2>/dev/null | grep -q "${tailscaleIP}"; then
            exit 0
          fi
          sleep 1
        done
        echo "Timed out waiting for Tailscale IP ${tailscaleIP}" >&2
        exit 1
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/caddy 0755 root root -"
  ];

  environment.etc."caddy/Caddyfile".text = ''
    :80 {
      @prowlarr host prowlarr.meihapps.gay
      reverse_proxy @prowlarr prowlarr:9696

      @lidarr host lidarr.meihapps.gay
      reverse_proxy @lidarr lidarr:8686

      @jellyfin host jellyfin.meihapps.gay
      reverse_proxy @jellyfin jellyfin:8096

      @qbittorrent host qbittorrent.meihapps.gay
      reverse_proxy @qbittorrent qbittorrent:8080

      @slskd host slskd.meihapps.gay
      reverse_proxy @slskd slskd:5030

      @openwebui host openwebui.meihapps.gay
      reverse_proxy @openwebui open-webui:8080

      @reader host jina.meihapps.gay
      reverse_proxy @reader jina-reader:8081
    }
  '';

  virtualisation.oci-containers.containers.caddy = {
    image = "docker.io/library/caddy:latest";
    ports = [ "${tailscaleIP}:80:80" ];
    volumes = [
      "/etc/caddy/Caddyfile:/etc/caddy/Caddyfile:ro"
      "/var/lib/caddy:/data"
    ];
    extraOptions = [ "--network=services" ];
  };

  systemd.services."docker-caddy" = {
    requires = [ "docker-network-services.service" "wait-for-tailscale-ip.service" ];
    after = [ "docker-network-services.service" "wait-for-tailscale-ip.service" ];
  };
}
