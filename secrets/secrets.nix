let
  mei      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvBaUH/v9Te7eFbAjyNpTVjuyP7h8fcsErmwUUxgyEZ";
  happuter = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJTHoVAMLQnl4TzcOYj3oPlSfCkt1vnPu5bMjLNBMtK6";
  all      = [ mei happuter ];
in
{
  "cargo-token.age".publicKeys            = all;
  "lidarr-api-key.age".publicKeys        = all;
  "prowlarr-api-key.age".publicKeys      = all;
  "slskd-config.age".publicKeys          = all;
  "mullvad-sjc-wg302-key.age".publicKeys = all;
}
