{ pkgs, ... }:
{
  home.stateVersion = "26.05";

  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "Fira Code";
      font-size = 16;
      theme = "Catppuccin Mocha";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user = {
        name = "mei happs";
        email = "mail@meihapps.gay";
      };
    };
  };
  
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, ghostty"
        "$mod + Shift, E, exit"
      ];
    };
  };
}
