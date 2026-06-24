{ ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Fira Code:size=11";
        width = 37;
        lines = 8;
        horizontal-pad = 12;
        vertical-pad = 12;
        inner-pad = 6;
        "border.width" = 1;
        "border.radius" = 14;
        fields = "filename,name,generic,keywords";
      };
      colors = {
        background = "181825ff";
        text = "cba6f7ff";
        match = "b4befeff";
        selection = "313244ff";
        selection-text = "cba6f7ff";
        selection-match = "b4befeff";
        border = "cba6f7ff";
        prompt = "cba6f7ff";
        input = "cba6f7ff";
      };
    };
  };
}
