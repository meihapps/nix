{ lib, pkgs, ... }:

{
  imports = [
    ../../modules/environment/editor.nix
    ../../modules/environment/fetch.nix
    ../../modules/environment/git.nix
    ../../modules/environment/packages.nix
    ../../modules/environment/shell.nix
  ];

  home.username = "mei";
  home.homeDirectory = "/home/mei";
  home.stateVersion = "26.05";

  home.packages = [ pkgs.tailscale ];

  programs.home-manager.enable = true;
  programs.fish.functions.reconfig.body = lib.mkForce ''
    home-manager switch --flake github:meihapps/nix#"mei@happi" --refresh
  '';
}
