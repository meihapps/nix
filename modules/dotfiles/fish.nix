{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fish

    fishPlugins.tide
  ];

  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting
    '';

    functions = {
      darwin-rebuild = {
        body = "nix run github:LnL7/nix-darwin -- \$argv";
        description = "Run darwin-rebuild command";
      };
    };
  };
}
