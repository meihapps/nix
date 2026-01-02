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

      hxnotes = {
        body = ''
          cd /Volumes/happssd/helix_notes
          set FNAME (date +'%Y-%m-%d_%H-%M-%S').md
          hx $FNAME
        '';
        description = "create and edit a new timestamped note with helix";
      };
    };
  };
}
