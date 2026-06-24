{ ... }:
{
  xdg.configFile."hypr/background.png".source = ./background.png;

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    splash = false
    preload = ~/.config/hypr/background.png

    wallpaper {
        monitor =
        path = ~/.config/hypr/background.png
        fit_mode = contain
    }
  '';
}
