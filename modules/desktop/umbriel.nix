{ config, inputs, ... }:
{
  programs.umbriel = {
    enable = true;
    # user config replaces the packaged one, so pull upstream defaults back in;
    # included tables merge by key and this file is applied last
    settings = {
      include.files = [ "${inputs.umbriel}/examples/config.toml" ];
      # palette rendered by noctalia's built-in umbriel template
      include.optional.files = [ "${config.xdg.configHome}/umbriel/noctalia.toml" ];
      general.autostart = [ "noctalia" ];
      input = {
        focus.follows_mouse = "always";
        keyboard = {
          layout = "gb";
          options = "caps:super";
        };
        mouse = {
          accel_profile = "flat";
          sensitivity = -0.6;
          natural_scroll = true;
        };
      };
      layout.mode = "dwindle";
      keybinds."Mod+Return" = {
        action = "spawn ghostty";
        repeat = false;
      };
    };
  };
}
