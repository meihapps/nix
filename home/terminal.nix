{ ... }:
{
  dconf.settings."org/gnome/desktop/interface".gtk-enable-primary-paste = true;

  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "Fira Code";
      font-size = 12;
      theme = "Catppuccin Mocha";
      palette = [
        "5=#cba6f7"
        "13=#cba6f7"
      ];
    };
  };
}
