{ ... }:
{
  imports = [
    ./caddy.nix
    ./flaresolverr.nix
    ./jellyfin.nix
    ./lidarr.nix
    ./plausible.nix
    ./prowlarr.nix
    ./qbittorrent.nix
    ./slskd.nix
    ./status.nix
    ./vaultwarden.nix
  ];

  # Shared with the NAS-backed services so they can read each other's files.
  # Pinned because the exFAT mount in storage.nix needs it as a number.
  users.groups.media.gid = 990;
}
