{ ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "none";
        origin = "top-right";
        offset = "(12, 12)";
        width = "(0, 320)";
        height = "(0, 300)";
        gap_size = 6;
        progress_bar_height = 8;
        progress_bar_frame_width = 0;
        progress_bar_max_width = 500;
        progress_bar_corner_radius = 4;
        highlight = "#313244";
        padding = 12;
        horizontal_padding = 16;
        frame_width = 1;
        frame_color = "#cba6f7";
        separator_color = "frame";
        corner_radius = 8;
        font = "Sans 11";
        markup = "full";
        word_wrap = true;
        icon_theme = "Adwaita";
        enable_recursive_icon_lookup = true;
        min_icon_size = 32;
      };
      urgency_low = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        frame_color = "#a6adc8";
        timeout = 5;
        script = "~/.local/bin/dunst-sound";
      };
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        frame_color = "#cba6f7";
        timeout = 5;
        script = "~/.local/bin/dunst-sound";
      };
      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        frame_color = "#f38ba8";
        timeout = 0;
        script = "~/.local/bin/dunst-sound";
      };
    };
  };
}
