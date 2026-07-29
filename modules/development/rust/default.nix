{ pkgs, inputs, ... }:
{
  age.secrets.cargo-token = {
    file = ../../../secrets/cargo-token.age;
    owner = "mei";
  };

  environment.systemPackages = with pkgs; [
    (inputs.fenix.packages.${pkgs.stdenv.hostPlatform.system}.stable.toolchain)
    rust-analyzer
    gcc
  ];

  home-manager.users.mei.imports = [
    ./credentials.nix
    ./helix.nix
  ];
}
