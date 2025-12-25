{ pkgs, ... }:

{
  imports = [
    ./modules/dotfiles
    ./modules/development.nix
    ./modules/entertainment.nix
    ./modules/productivity.nix
    ./modules/shell-tools.nix
  ];

  home.username = "meihapps";
  home.homeDirectory = "/Users/meihapps";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    nil
    nixd
  ];

  home.shellAliases = {
    rebuild-nix = "sudo HOME=/var/root nix run github:LnL7/nix-darwin -- switch --flake ~/.config/nix#happtop";
    rebuild-nix-rollback = "sudo HOME=/var/root nix run github:LnL7/nix-darwin -- switch --rollback --flake ~/.config/nix#happtop";
  };

  programs.home-manager.enable = true;
}
