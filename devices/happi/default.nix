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

  home.activation.setFishAsDefaultShell = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if ! grep -qF "$HOME/.nix-profile/bin/fish" /etc/shells; then
      echo "$HOME/.nix-profile/bin/fish" | sudo tee -a /etc/shells > /dev/null
    fi
    if [ "$SHELL" != "$HOME/.nix-profile/bin/fish" ]; then
      sudo chsh -s "$HOME/.nix-profile/bin/fish" mei
    fi
  '';
}
