# Noctalia settings, mirrored from the GUI by the dmopp/settings-to-nix plugin
# (/home/mei/.local/state/noctalia/settings.toml). Every export overwrites this file.
#
# This file is your backup: keep it somewhere safe, for example in git.
#
# To restore, run this as your user in the directory of this file:
#   $(nix-build --no-out-link ./noctalia_settings.nix)/bin/noctalia-restore-settings
# It replaces settings.toml (the old one is kept as settings.toml.bak-<time>).
# Then restart Noctalia; it installs the plugins listed here again on startup.
{ pkgs ? import <nixpkgs> { } }:
let
  settings = {
    audio.colorize_icons = true;
    bar.default = {
      end = [
        "media"
        "tray"
        "notifications"
        "network"
        "bluetooth"
        "volume"
        "brightness"
        "battery"
        "control-center"
        "session"
      ];
      margin_ends = "25%";
      start = [
        "workspaces"
        "current"
        "nix-monitor"
        "indicator"
        "widget"
        "bar_2"
        "status"
        "bar_3"
        "bar_4"
      ];
    };
    config_version = 20;
    desktop_widgets = {
      grid = {
        cell_size = 16;
        major_interval = 4;
        visible = true;
      };
      schema_version = 2;
      widget = {
        desktop-widget-0000000000000001 = {
          box_height = 0.0;
          box_width = 0.0;
          cx = 1280.0;
          cy = 540.0;
          output = "DP-1";
          placement_height = 1080.0;
          placement_width = 2560.0;
          rotation = 0.0;
          type = "noctalia/lyrics:desktop";
        };
        desktop-widget-0000000000000002 = {
          box_height = 0.0;
          box_width = 0.0;
          cx = 2396.5;
          cy = 79.0;
          output = "DP-1";
          placement_height = 1080.0;
          placement_width = 2560.0;
          rotation = 0.0;
          type = "rylos/tailnet:desktop";
        };
        desktop-widget-0000000000000003 = {
          box_height = 0.0;
          box_width = 0.0;
          cx = 1280.0;
          cy = 902.0;
          output = "DP-1";
          placement_height = 1080.0;
          placement_width = 2560.0;
          rotation = 0.0;
          settings.background = false;
          type = "fancy_audio_visualizer";
        };
        desktop-widget-0000000000000004 = {
          box_height = 0.0;
          box_width = 0.0;
          cx = 1280.0;
          cy = 300.0;
          output = "DP-1";
          placement_height = 1080.0;
          placement_width = 2560.0;
          rotation = 0.0;
          type = "media_player";
        };
      };
      widget_order = [
        "desktop-widget-0000000000000001"
        "desktop-widget-0000000000000002"
        "desktop-widget-0000000000000003"
        "desktop-widget-0000000000000004"
      ];
    };
    dock.colorize_icons = true;
    location.auto_locate = true;
    lockscreen_widgets = {
      enabled = false;
      grid = {
        cell_size = 16;
        major_interval = 4;
        visible = true;
      };
      schema_version = 2;
      widget = {
        "lockscreen-login-box@DP-1" = {
          box_height = 196.0;
          box_width = 810.0;
          cx = 1280.0;
          cy = 898.0;
          output = "DP-1";
          placement_height = 1080.0;
          placement_width = 2560.0;
          rotation = 0.0;
          settings = {
            background_color = "surface_container";
            background_opacity = 0.88;
            background_radius = 12.0;
            center_password_text = false;
            input_opacity = 1.0;
            input_radius = 6.0;
            layout = "regular";
            show_caps_lock = true;
            show_keyboard_layout = true;
            show_login_button = true;
            show_media = true;
            show_media_controls = true;
            show_password_reveal = true;
            show_session_buttons = true;
            show_unlock_hint = true;
            show_weather = true;
          };
          type = "login_box";
        };
        "lockscreen-login-box@WL-1" = {
          box_height = 196.0;
          box_width = 720.0;
          cx = 1280.0;
          cy = 890.6357421875;
          output = "WL-1";
          placement_height = 1080.0;
          placement_width = 2560.0;
          rotation = 0.0;
          settings = {
            background_color = "surface_container";
            background_opacity = 0.88;
            background_radius = 12.0;
            center_password_text = false;
            input_opacity = 1.0;
            input_radius = 6.0;
            layout = "regular";
            show_caps_lock = true;
            show_keyboard_layout = true;
            show_login_button = true;
            show_media = true;
            show_media_controls = true;
            show_password_reveal = true;
            show_session_buttons = true;
            show_unlock_hint = true;
            show_weather = true;
          };
          type = "login_box";
        };
      };
      widget_order = [ "lockscreen-login-box@WL-1" "lockscreen-login-box@DP-1" ];
    };
    notification.colorize_icons = true;
    plugin_settings = {
      "dmopp/settings-to-nix".target_path = "/etc/nixos/modules/desktop/noctalia_settings.nix";
      "noctalia/bitwarden".server_url = "https://passwords.meihapps.gay";
    };
    plugins.enabled = [
      "noctalia/umbriel-companion"
      "thaer99ob/default-apps"
      "alexander/screen-toolkit"
      "noctalia/bitwarden"
      "prponkshe/umbriel-displays"
      "radimous/prismlauncher-instances"
      "detluck/performance-plus"
      "aristides/udiskie"
      "noctalia/lyrics"
      "avivbintangaringga/nix-monitor"
      "rylos/tailnet"
      "dmopp/settings-to-nix"
      "asj/task-warrior"
    ];
    shell = {
      button_borders = false;
      circular_avatar = false;
      input_borders = false;
      launcher.colorize_icons = true;
      polkit_colorize_icons = true;
      screen_time_colorize_icons = true;
      settings_expand_all_groups = true;
      window_switcher.colorize_icons = true;
    };
    theme = {
      builtin = "Noctalia";
      community_palette = "Monochrome";
      mode = "dark";
      source = "wallpaper";
      wallpaper_scheme = "muted";
    };
    widget = {
      bar_2.type = "rylos/tailnet:bar";
      bar_3.type = "noctalia/umbriel-companion:bar";
      bar_4.type = "prponkshe/umbriel-displays:bar";
      current.type = "thaer99ob/default-apps:current";
      indicator.type = "detluck/performance-plus:indicator";
      media.album_art_only = true;
      network.show_label = false;
      nix-monitor = {
        show_text = false;
        type = "avivbintangaringga/nix-monitor:nix-monitor";
      };
      status.type = "aristides/udiskie:status";
      widget.type = "alexander/screen-toolkit:widget";
    };
  };
  settingsToml = (pkgs.formats.toml { }).generate "noctalia-settings.toml" settings;
in
(pkgs.writeShellScriptBin "noctalia-restore-settings" ''
  set -eu
  PATH=${pkgs.coreutils}/bin:$PATH
  if [ -n "''${NOCTALIA_STATE_HOME:-}" ]; then
    dir="$NOCTALIA_STATE_HOME/noctalia"
  elif [ -n "''${XDG_STATE_HOME:-}" ]; then
    dir="$XDG_STATE_HOME/noctalia"
  else
    dir="$HOME/.local/state/noctalia"
  fi
  mkdir -p "$dir"
  if [ -e "$dir/settings.toml" ]; then
    backup="$dir/settings.toml.bak-$(date +%Y%m%d-%H%M%S)"
    cp "$dir/settings.toml" "$backup"
    echo "Previous settings saved to $backup"
  fi
  tmp=$(mktemp "$dir/.settings.toml.XXXXXX")
  cat ${settingsToml} > "$tmp"
  chmod 644 "$tmp"
  mv "$tmp" "$dir/settings.toml"
  # Skip the first-run wizard; it would write its own choices over the restored ones.
  touch "$dir/.setup-complete"
  echo "Noctalia settings restored to $dir/settings.toml."
  echo "Restart Noctalia so it installs the plugins from the restored settings."
'') // { inherit settings; }
