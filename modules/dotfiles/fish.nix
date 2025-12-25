{ ... }:

{
  programs.fish = {
    enable = true;
    shellInit = ''
      set -gx PATH ~/.nix-profile/bin $PATH

      # Add homebrew fish functions to fish_function_path
      if test -d (brew --prefix)/share/fish/vendor_functions.d
        set -gx fish_function_path (brew --prefix)/share/fish/vendor_functions.d $fish_function_path
      end
    '';
    functions = {
      darwin-rebuild = {
        body = "nix run github:LnL7/nix-darwin -- \$argv";
        description = "Run darwin-rebuild command";
      };
    };
  };

  home.file.".config/fish/fish_plugins" = {
    text = ''
      ilancosman/tide@v6
      icezyclon/zoxide.fish
    '';
  };
}
