{ ... }:
{
  xdg.configFile."hypr/hyprland-device.lua".text = ''
    -- Monitor (highest available resolution and framerate, 1x scale)
    hl.monitor({ output = "", mode = "preferred", position = "0x0", scale = 1 })

    -- Brightness (laptop backlight via kernel interface)
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })
    hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"), { repeating = true })

    -- Mic mute (F4)
    hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))

    -- Display switch (F7)
    hl.bind("XF86Display", hl.dsp.exec_cmd("wdisplays"))

    -- Airplane / RF kill (F8)
    hl.bind("XF86RFKill", hl.dsp.exec_cmd("rfkill toggle all"))

    -- F9 (settings icon) → firefox special workspace
    hl.window_rule({ match = { class = "firefox" }, workspace = "special:firefox" })
    hl.bind("XF86Tools", function()
      local ws = hl.get_workspace("special:firefox")
      if ws ~= nil and ws.windows > 0 then
        hl.dispatch(hl.dsp.workspace.toggle_special("firefox"))
      else
        hl.dispatch(hl.dsp.exec_cmd("firefox"))
      end
    end)

    -- F10 (bluetooth icon) → vesktop special workspace
    hl.bind("XF86Bluetooth", function()
      local ws = hl.get_workspace("special:vesktop")
      if ws ~= nil and ws.windows > 0 then
        hl.dispatch(hl.dsp.workspace.toggle_special("vesktop"))
      else
        hl.dispatch(hl.dsp.exec_cmd("vesktop"))
      end
    end)

    -- F11 (keyboard icon) → steam special workspace
    hl.bind("XF86Keyboard", function()
      local ws = hl.get_workspace("special:steam")
      if ws ~= nil and ws.windows > 0 then
        hl.dispatch(hl.dsp.workspace.toggle_special("steam"))
      else
        hl.dispatch(hl.dsp.exec_cmd("steam"))
      end
    end)

    -- F12 (star icon) → placeholder
    hl.bind("XF86Favorites", hl.dsp.exec_cmd("true"))

    -- Trackpad sensitivity override
    hl.config({ input = { sensitivity = 0 } })

    hl.env("XCURSOR_SIZE", "24")
  '';
}
