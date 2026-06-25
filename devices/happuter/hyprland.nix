{ ... }:
{
  xdg.configFile."hypr/hyprland-device.lua".text = ''
    local mod = "SUPER"

    -- Monitor (5120x2160 ultrawide @ 120Hz, 2x HiDPI scale)
    hl.monitor({ output = "", mode = "5120x2160@120", position = "0x0", scale = 2 })

    -- Brightness (external monitor via DDC/CI on bus 11)
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("ddcutil setvcp 10 - 5 --bus 11 --noverify --sleep-multiplier .1 --disable-dynamic-sleep"), { repeating = true })
    hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("ddcutil setvcp 10 + 5 --bus 11 --noverify --sleep-multiplier .1 --disable-dynamic-sleep"), { repeating = true })

    -- Numpad binds
    hl.bind(mod .. " + KP_Down", hl.dsp.layout("togglesplit"))
    hl.bind(mod .. " + KP_End", hl.dsp.window.float())
    hl.bind(mod .. " + KP_End", hl.dsp.window.pin())

    -- Scale environment (2x HiDPI)
    hl.env("GDK_SCALE", "2")
    hl.env("QT_SCALE_FACTOR", "2")
    hl.env("XCURSOR_SIZE", "32")
    hl.env("AVALONIA_SCREEN_SCALE_FACTORS", "DP-1=2")
  '';
}
