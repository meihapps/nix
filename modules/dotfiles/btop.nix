{ ... }:

{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "tokyo-night";
      presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
      rounded_corners = true;
      graph_symbol = "braille";
      shown_boxes = "net cpu mem proc";
      update_ms = 2000;
      proc_sorting = "cpu lazy";
      cpu_invert_lower = true;
      net_download = 100;
      net_upload = 100;
    };
  };
}
