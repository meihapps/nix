{ pkgs, ... }:
{
  xdg.configFile."catnap/distros.toml".source = "${pkgs.callPackage ./catnap.nix {}}/share/catnap/distros.toml";

  xdg.configFile."catnap/config.toml".text = ''
    [stats]
    username  = {icon = " ", name = "user", color = "(MA)"}
    hostname  = {icon = " ", name = "hostname", color = "(MA)"}

    sep_software = "SEPARATOR"

    desktop   = {icon = " ", name = "desktop", color = "(RD)"}
    shell     = {icon = " ", name = "shell", color = "(BE)"}
    kernel    = {icon = " ", name = "kernel", color = "(BE)"}

    sep_color = "SEPARATOR"

    colors    = {icon = " ", name = "colors", color = "!DT!", symbol = "●"}

    [misc]
    layout = "Inline"
    borderstyle = "line"
    stats_margin_top = 1
  '';
}
