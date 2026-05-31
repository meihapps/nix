{ pkgs, ... }:
{
  xdg.configFile."hypr/hyprland.lua".text = ''
    -- Variables
    local mod = "SUPER"
    local term = "ghostty"
    local menu = "pkill fuzzel || fuzzel"

    -- Monitors
    hl.monitor({ output = "", mode = "5120x2160@120", position = "0x0", scale = 2 })

    -- Config sections
    hl.config({
        dwindle = {
            preserve_split = true,
        },
        general = {
            gaps_in = 4,
            gaps_out = 8,
            border_size = 1,
            ["col.active_border"] = "0xffb4befe",
            ["col.inactive_border"] = "0xff1e1e2e",
            layout = "dwindle",
        },
        input = {
            kb_layout = "gb",
            kb_variant = "mac",
            kb_options = "caps:super",
            natural_scroll = true,
            accel_profile = "flat",
            sensitivity = -0.6,
        },
        misc = {
            disable_hyprland_logo = true,
            disable_splash_rendering = true,
            force_default_wallpaper = 0,
        },
        xwayland = {
            force_zero_scaling = true,
        },
    })

    -- Keybinds
    hl.bind(mod .. " + Return", hl.dsp.exec_cmd(term))
    hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())
    hl.bind(mod .. " + Space", hl.dsp.exec_cmd(menu))
    hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())
    hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen())
    hl.bind(mod .. " + SHIFT + Space", hl.dsp.window.float())
    hl.bind(mod .. " + SHIFT + P", hl.dsp.window.pin())
    hl.bind(mod .. " + L", hl.dsp.exec_cmd("hyprlock"))

    -- Alt+n (GB keyboard dead keys)
    hl.bind("ALT + 1", hl.dsp.exec_cmd("true"))
    hl.bind("ALT + 2", hl.dsp.exec_cmd("wtype €"))
    hl.bind("ALT + 3", hl.dsp.exec_cmd("wtype '##'"))
    hl.bind("ALT + 4", hl.dsp.exec_cmd("true"))
    hl.bind("ALT + 5", hl.dsp.exec_cmd("true"))
    hl.bind("ALT + 6", hl.dsp.exec_cmd("true"))
    hl.bind("ALT + 7", hl.dsp.exec_cmd("true"))
    hl.bind("ALT + 8", hl.dsp.exec_cmd("true"))
    hl.bind("ALT + 9", hl.dsp.exec_cmd("true"))
    hl.bind("ALT + 0", hl.dsp.exec_cmd("true"))

    -- Focus
    hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "l" }))
    hl.bind(mod .. " + right", hl.dsp.focus({ direction = "r" }))
    hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "u" }))
    hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "d" }))

    -- Move windows
    hl.bind(mod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))
    hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
    hl.bind(mod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
    hl.bind(mod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))

    -- Window Mouse Binds
    hl.bind(mod .. " + mouse:272", hl.dsp.window.drag())
    hl.bind(mod .. " + mouse:273", hl.dsp.window.resize())
    hl.bind(mod .. " + mouse:278", hl.dsp.layout("togglesplit"))

    -- Workspaces
    hl.bind(mod .. " + 1", hl.dsp.focus({ workspace = 1 }))
    hl.bind(mod .. " + 2", hl.dsp.focus({ workspace = 2 }))
    hl.bind(mod .. " + 3", hl.dsp.focus({ workspace = 3 }))
    hl.bind(mod .. " + 4", hl.dsp.focus({ workspace = 4 }))
    hl.bind(mod .. " + 5", hl.dsp.focus({ workspace = 5 }))
    hl.bind(mod .. " + 6", hl.dsp.focus({ workspace = 6 }))
    hl.bind(mod .. " + 7", hl.dsp.focus({ workspace = 7 }))
    hl.bind(mod .. " + 8", hl.dsp.focus({ workspace = 8 }))
    hl.bind(mod .. " + 9", hl.dsp.focus({ workspace = 9 }))

    hl.bind(mod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
    hl.bind(mod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
    hl.bind(mod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
    hl.bind(mod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
    hl.bind(mod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
    hl.bind(mod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
    hl.bind(mod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
    hl.bind(mod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
    hl.bind(mod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))

    -- Brightness (ddcutil on bus 8)
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("ddcutil setvcp 10 - 5 --bus 8 --noverify --sleep-multiplier .1 --disable-dynamic-sleep"), { repeating = true })
    hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("ddcutil setvcp 10 + 5 --bus 8 --noverify --sleep-multiplier .1 --disable-dynamic-sleep"), { repeating = true })

    -- Media / volume
    hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"), { repeating = true })
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"), { repeating = true })
    hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous --player playerctld"))
    hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause --player playerctld"))
    hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next --player playerctld"))

    -- Screenshots
    hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region"))

    -- Clipboard
    hl.bind(mod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))

    -- Window Rules
    hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol" }, float = true, size = {"500", "700"}, move = {"monitor_w-500", "50"} })
    hl.window_rule({ match = { class = "org.twosheds.iwgtk" },         float = true, size = {"500", "700"}, move = {"monitor_w-500", "50"} })
    hl.window_rule({ match = { class = "swayimg" }, float = true })

    -- Firefox special workspace
    hl.window_rule({ match = { class = "firefox" }, workspace = "special:firefox" })
    hl.bind(mod .. " + B", function()
      local ws = hl.get_workspace("special:firefox")
      if ws ~= nil and ws.windows > 0 then
        hl.dispatch(hl.dsp.workspace.toggle_special("firefox"))
      else
        hl.dispatch(hl.dsp.exec_cmd("firefox"))
      end
    end)

    -- Vesktop special workspace
    hl.window_rule({ match = { class = "vesktop" }, workspace = "special:vesktop" })
    hl.bind(mod .. " + D", function()
      local ws = hl.get_workspace("special:vesktop")
      if ws ~= nil and ws.windows > 0 then
        hl.dispatch(hl.dsp.workspace.toggle_special("vesktop"))
      else
        hl.dispatch(hl.dsp.exec_cmd("vesktop"))
      end
    end)

    -- Steam special workspace
    hl.window_rule({ match = { class = "steam" }, workspace = "special:steam silent" })
    hl.bind(mod .. " + S", function()
      local ws = hl.get_workspace("special:steam")
      if ws ~= nil and ws.windows > 0 then
        hl.dispatch(hl.dsp.workspace.toggle_special("steam"))
      else
        hl.dispatch(hl.dsp.exec_cmd("steam"))
      end
    end)

    -- Picture in Picture
    hl.window_rule({ match = { title = "^Picture-in-Picture$" }, float = true, pin = true, keep_aspect_ratio = true })
    hl.bind(mod .. " + mouse:277", hl.dsp.window.float())
    hl.bind(mod .. " + mouse:277", hl.dsp.window.pin())

    -- Startup
    hl.on("hyprland.start", function()
        hl.exec_cmd("${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1")
        hl.exec_cmd("ashell")
        hl.exec_cmd("hyprpaper")
        hl.exec_cmd("hyprlock")
        hl.exec_cmd("dunst")
        hl.exec_cmd("wl-paste --watch cliphist store")
        hl.exec_cmd("wl-paste --primary --watch cliphist store")
        hl.exec_cmd("pactl set-card-profile alsa_card.pci-0000_00_1f.3 output:hdmi-stereo+input:analog-stereo")
    end)

    -- Environment
    hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
    hl.env("XDG_SESSION_TYPE", "wayland")
    hl.env("XDG_SESSION_DESKTOP", "Hyprland")
    hl.env("GDK_SCALE", "2")
    hl.env("QT_SCALE_FACTOR", "2")
    hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
    hl.env("XCURSOR_SIZE", "32")
    hl.env("AVALONIA_SCREEN_SCALE_FACTORS", "DP-1=2")
  '';
}
