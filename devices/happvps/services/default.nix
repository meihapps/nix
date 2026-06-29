{ ... }:
{
  imports = [
    ./caddy.nix
    ./flaresolverr.nix
    ./plausible.nix
    ./status.nix
    ./vaultwarden.nix
    ./website.nix
  ];

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
}
