{ ... }:

{
  programs.fish = {
    enable = true;
    shellInit = ''
      set -gx PATH ~/.nix-profile/bin $PATH
    '';
    functions = {
      darwin-rebuild = {
        body = "nix run github:LnL7/nix-darwin -- \$argv";
        description = "Run darwin-rebuild command";
      };
    };
  };

  home.file.".config/fish/fish_plugins" = {
    text = "ilancosman/tide@v6";
  };
}
