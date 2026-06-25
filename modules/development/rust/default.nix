{ pkgs, ... }:
{
  age.secrets.cargo-token = {
    file = ../../../secrets/cargo-token.age;
    owner = "mei";
  };

  environment.systemPackages = with pkgs; [ rustup gcc ];

  home-manager.users.mei.imports = [
    ./credentials.nix
    ./helix.nix
  ];
}
