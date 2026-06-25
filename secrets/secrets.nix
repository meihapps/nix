let
  mei      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvBaUH/v9Te7eFbAjyNpTVjuyP7h8fcsErmwUUxgyEZ";
  happuter = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJTHoVAMLQnl4TzcOYj3oPlSfCkt1vnPu5bMjLNBMtK6";
  happtop  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA11+GPUvCi/Foqw182mFiOZXhk9PUDvI1uoWMAmLz6m";
  happvps  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOffzKbywSLj5zC5uNSneBoanDMwlyVUpzRgQNPIp9JQ";
  all      = [ mei happuter happtop ];
  vps      = [ mei happvps ];
in
{
  "cargo-token.age".publicKeys                    = all;
  "lidarr-api-key.age".publicKeys                = all;
  "porkbun-api-key.age".publicKeys                = all;
  "porkbun-secret-key.age".publicKeys            = all;
  "prowlarr-api-key.age".publicKeys              = all;
  "slskd-config.age".publicKeys                  = all;
  "mullvad-sjc-wg302-key.age".publicKeys         = all;
  "socks5-proxy.age".publicKeys                  = all;
  "vaultwarden-admin-token.age".publicKeys = vps;
  "plausible-secret-key.age".publicKeys          = vps;
}
