{ ... }:
{
  imports = [
    ./editor.nix
    ./fetch.nix
    ./git.nix
    ./packages.nix
    ./shell.nix
  ];

  home.stateVersion = "26.05";
}
