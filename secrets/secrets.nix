let
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvBaUH/v9Te7eFbAjyNpTVjuyP7h8fcsErmwUUxgyEZ";
in
{
  "cargo-token.age".publicKeys                   = key;
  "lidarr-api-key.age".publicKeys                = key;
  "porkbun-api-key.age".publicKeys               = key;
  "porkbun-secret-key.age".publicKeys            = key;
  "prowlarr-api-key.age".publicKeys              = key;
  "slskd-config.age".publicKeys                  = key;
  "mullvad-sjc-wg302-key.age".publicKeys         = key;
  "socks5-proxy.age".publicKeys                  = key;
  "vaultwarden-admin-token.age".publicKeys       = key;
  "plausible-secret-key.age".publicKeys          = key;
}
