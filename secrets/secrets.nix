let
  # Your SSH public key — used for editing secrets from any machine you own
  mei = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvBaUH/v9Te7eFbAjyNpTVjuyP7h8fcsErmwUUxgyEZ";

  # Machine host key — run this after first NixOS boot and re-encrypt:
  #   sudo cat /etc/ssh/ssh_host_ed25519_key.pub
  #   nix run github:ryantm/agenix -- -r <host-key> secrets/lidarr-api-key.age
  #   nix run github:ryantm/agenix -- -r <host-key> secrets/prowlarr-api-key.age
in
{
  "lidarr-api-key.age".publicKeys   = [ mei ];
  "prowlarr-api-key.age".publicKeys = [ mei ];
  "slskd-config.age".publicKeys     = [ mei ];
}
