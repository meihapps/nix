{ lib, ... }:
{
  home.activation.cargo-credentials = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ~/.cargo
    printf '[registry]\ntoken = "%s"\n' "$(cat /run/agenix/cargo-token)" > ~/.cargo/credentials.toml
    chmod 600 ~/.cargo/credentials.toml
  '';
}
