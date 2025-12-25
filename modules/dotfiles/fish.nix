{ pkgs, ... }:

{
  home.packages = with pkgs.fishPlugins; [
    tide
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
      cd = {
        body = "z";
        description = "Run z using cd as alias";
      };
    };
  };
}
