{ ... }:
{
  programs.caelestia = {
    enable = true;
    cli.enable = true;
  };

  xdg.configFile."caelestia/hypr-user.lua".text = ''
    hl.monitor({
        output = "",
        mode = "preferred",
        position = "auto",
        scale = 2,
    })

    hl.config({
      input = {
        kb_options = "caps:super",
        sensitivity = -0.6,
        accel_profile = "flat",
        natural_scroll = true,
      },
    })
  '';

  xdg.configFile."caelestia/hypr-vars.lua".text = ''
    return {
        terminal = "ghostty",
        browser = "zen-beta",
        editor = "hx",
        volumeStep = 5,
        volumeMax = 200,
        kbMoveWinToWs = "SUPER + SHIFT",
        kbMoveWinToWsGroup = "CTRL + SUPER + SUPER",
    }
  '';

  xdg.configFile."caelestia/templates/ghostty".text = ''
    background = #{{ surface.hex }}
    foreground = #{{ onSurface.hex }}
    cursor-color = #{{ secondary.hex }}
    selection-background = #{{ secondary.hex }}
    selection-foreground = #{{ onSecondary.hex }}

    palette = 0=#{{ term0.hex }}
    palette = 1=#{{ term1.hex }}
    palette = 2=#{{ term2.hex }}
    palette = 3=#{{ term3.hex }}
    palette = 4=#{{ term4.hex }}
    palette = 5=#{{ term5.hex }}
    palette = 6=#{{ term6.hex }}
    palette = 7=#{{ term7.hex }}
    palette = 8=#{{ term8.hex }}
    palette = 9=#{{ term9.hex }}
    palette = 10=#{{ term10.hex }}
    palette = 11=#{{ term11.hex }}
    palette = 12=#{{ term12.hex }}
    palette = 13=#{{ term13.hex }}
    palette = 14=#{{ term14.hex }}
    palette = 15=#{{ term15.hex }}
  '';}
