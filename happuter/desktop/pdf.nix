{ ... }:
{
  programs.zathura = {
    enable = true;
    mappings = {
      "<Right>" = "navigate next";
      "<Left>" = "navigate previous";
    };
  };
}
