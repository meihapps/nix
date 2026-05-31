{ pkgs, ... }:
{
  home.stateVersion = "26.05";

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 32;
    gtk.enable = true;
    hyprcursor.enable = true;
  };

  home.packages = with pkgs; [
    claude-code
    ashell
    zoxide
    eza
    bat
    ripgrep
    fd
    ani-cli
    wireguard-tools
    taskwarrior3
    vesktop
    hyprshot
    hyprpaper
    hyprlock
    wl-clipboard
    cliphist
    playerctl
    ddcutil
    wtype
    (callPackage ./catnap.nix {})
  ];

  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "none";
        origin = "top-right";
        offset = "(12, 12)";
        width = "(0, 320)";
        height = "(0, 300)";
        gap_size = 6;
        progress_bar_height = 8;
        progress_bar_frame_width = 0;
        progress_bar_max_width = 500;
        progress_bar_corner_radius = 4;
        highlight = "#313244";
        padding = 12;
        horizontal_padding = 16;
        frame_width = 1;
        frame_color = "#cba6f7";
        separator_color = "frame";
        corner_radius = 8;
        font = "Sans 11";
        markup = "full";
        word_wrap = true;
        icon_theme = "Adwaita";
        enable_recursive_icon_lookup = true;
        min_icon_size = 32;
      };
      urgency_low = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        frame_color = "#a6adc8";
        timeout = 5;
        script = "~/.local/bin/dunst-sound";
      };
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        frame_color = "#cba6f7";
        timeout = 5;
        script = "~/.local/bin/dunst-sound";
      };
      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        frame_color = "#f38ba8";
        timeout = 0;
        script = "~/.local/bin/dunst-sound";
      };
    };
  };

  xdg.configFile."dolphinrc".text = ''
    [General]
    Version=202

    [KFileDialog Settings]
    Places Icons Auto-resize=false
    Places Icons Static Size=22

    [MainWindow]
    MenuBar=Disabled
  '';

  xdg.configFile."dolphin-emu/Dolphin.ini".text = ''
    [Core]
    GFXBackend = Vulkan
    [DSP]
    DSPThread = True
    [General]
    ISOPath0 = /home/meihapps/dolphins
    ISOPaths = 1
    [NetPlay]
    TraversalChoice = direct
  '';

  xdg.configFile."dolphin-emu/GFX.ini".text = ''
    [Enhancements]
    PostProcessingShader =
    [Settings]
    InternalResolution = 2
  '';

  xdg.configFile."dolphin-emu/GCPadNew.ini".text = ''
    [GCPad1]
    Device = evdev/0/Microsoft Xbox Series S|X Controller
    Buttons/A = SOUTH
    Buttons/B = EAST
    Buttons/X = NORTH
    Buttons/Y = WEST
    Buttons/Z = TR
    Buttons/Start = START
    Main Stick/Up = `Axis 1-`
    Main Stick/Down = `Axis 1+`
    Main Stick/Left = `Axis 0-`
    Main Stick/Right = `Axis 0+`
    Main Stick/Modifier = THUMBL
    Main Stick/Calibration = 100.00 101.96 105.85 102.80 103.79 108.84 108.24 101.96 100.00 101.96 108.24 120.27 124.79 119.12 108.24 101.96 100.00 101.96 108.24 117.04 118.65 119.18 108.24 101.96 100.00 101.96 108.24 109.41 112.86 112.01 106.26 101.43
    C-Stick/Up = `Axis 4-`
    C-Stick/Down = `Axis 4+`
    C-Stick/Left = `Axis 3-`
    C-Stick/Right = `Axis 3+`
    C-Stick/Modifier = THUMBR
    C-Stick/Calibration = 100.00 101.96 101.24 106.64 113.02 113.80 107.42 101.96 100.00 101.96 108.24 114.48 114.06 116.27 108.24 101.96 100.00 101.96 108.24 120.27 124.79 117.42 108.24 101.96 98.45 98.56 102.61 103.41 101.32 109.16 106.24 101.96
    D-Pad/Up = `Axis 7-`
    D-Pad/Down = `Axis 7+`
    D-Pad/Left = `Axis 6-`
    D-Pad/Right = `Axis 6+`
    Triggers/L-Analog = `Full Axis 2+`
    Triggers/R-Analog = `Full Axis 5+`
    [GCPad2]
    Device = XInput2/0/Virtual core pointer
    [GCPad3]
    Device = XInput2/0/Virtual core pointer
    [GCPad4]
    Device = XInput2/0/Virtual core pointer
  '';

  xdg.configFile."dolphin-emu/WiimoteNew.ini".text = ''
    [Wiimote1]
    Device = XInput2/0/Virtual core pointer
    Buttons/A = `Click 1`
    Buttons/B = `Click 3`
    Buttons/1 = `1`
    Buttons/2 = `2`
    Buttons/- = Q
    Buttons/+ = E
    Buttons/Home = Return
    D-Pad/Up = Up
    D-Pad/Down = Down
    D-Pad/Left = Left
    D-Pad/Right = Right
    IR/Up = `Cursor Y-`
    IR/Down = `Cursor Y+`
    IR/Left = `Cursor X-`
    IR/Right = `Cursor X+`
    Shake/X = `Click 2`
    Shake/Y = `Click 2`
    Shake/Z = `Click 2`
    IRPassthrough/Object 1 X = `IR Object 1 X`
    IRPassthrough/Object 1 Y = `IR Object 1 Y`
    IRPassthrough/Object 1 Size = `IR Object 1 Size`
    IRPassthrough/Object 2 X = `IR Object 2 X`
    IRPassthrough/Object 2 Y = `IR Object 2 Y`
    IRPassthrough/Object 2 Size = `IR Object 2 Size`
    IRPassthrough/Object 3 X = `IR Object 3 X`
    IRPassthrough/Object 3 Y = `IR Object 3 Y`
    IRPassthrough/Object 3 Size = `IR Object 3 Size`
    IRPassthrough/Object 4 X = `IR Object 4 X`
    IRPassthrough/Object 4 Y = `IR Object 4 Y`
    IRPassthrough/Object 4 Size = `IR Object 4 Size`
    IMUAccelerometer/Up = `Accel Up`
    IMUAccelerometer/Down = `Accel Down`
    IMUAccelerometer/Left = `Accel Left`
    IMUAccelerometer/Right = `Accel Right`
    IMUAccelerometer/Forward = `Accel Forward`
    IMUAccelerometer/Backward = `Accel Backward`
    IMUGyroscope/Pitch Up = `Gyro Pitch Up`
    IMUGyroscope/Pitch Down = `Gyro Pitch Down`
    IMUGyroscope/Roll Left = `Gyro Roll Left`
    IMUGyroscope/Roll Right = `Gyro Roll Right`
    IMUGyroscope/Yaw Left = `Gyro Yaw Left`
    IMUGyroscope/Yaw Right = `Gyro Yaw Right`
    Extension = Nunchuk
    Nunchuk/Buttons/C = Control_L
    Nunchuk/Buttons/Z = Shift_L
    Nunchuk/Stick/Up = W
    Nunchuk/Stick/Down = S
    Nunchuk/Stick/Left = A
    Nunchuk/Stick/Right = D
    Nunchuk/Stick/Calibration = 100.00 141.42 100.00 141.42 100.00 141.42 100.00 141.42
    Nunchuk/Shake/X = `Click 2`
    Nunchuk/Shake/Y = `Click 2`
    Nunchuk/Shake/Z = `Click 2`
    [Wiimote2]
    Device = XInput2/0/Virtual core pointer
    [Wiimote3]
    Device = XInput2/0/Virtual core pointer
    [Wiimote4]
    Device = XInput2/0/Virtual core pointer
    [BalanceBoard]
    Device = XInput2/0/Virtual core pointer
  '';

  xdg.configFile."catnap/distros.toml".source = "${pkgs.callPackage ./catnap.nix {}}/share/catnap/distros.toml";

  xdg.configFile."catnap/config.toml".text = ''
    [stats]
    username  = {icon = " ", name = "user", color = "(MA)"}
    hostname  = {icon = " ", name = "hostname", color = "(MA)"}

    sep_software = "SEPARATOR"

    desktop   = {icon = " ", name = "desktop", color = "(RD)"}
    shell     = {icon = " ", name = "shell", color = "(BE)"}

    sep_color = "SEPARATOR"

    colors    = {icon = " ", name = "colors", color = "!DT!", symbol = "●"}

    [misc]
    layout = "Inline"
    borderstyle = "line"
    distro = "arch"
    stats_margin_top = 1
  '';

  xdg.configFile."ashell/config.toml".text = ''
    [modules]
    left = [ "Workspaces" ]
    center = [ "Clock", "tasks" ]
    right = [ "Tray", "Privacy", "Settings" ]

    [clock]
    format = "%Y-%m-%d %H:%M:%S"

    [[CustomModule]]
    name = "tasks"
    type = "Text"
    listen_cmd = "sh -c 'while true; do echo \"{\\\"text\\\": \\\"$(task due.before:now status:pending count 2>/dev/null)\\\", \\\"alt\\\": \\\"\\\"}\"; sleep 5; done'"

    [settings]
    remove_airplane_btn = true

[workspaces]
    disable_special_workspaces = true

    # Catppuccin
    [appearance]
    font_name = "Fira Sans"
    success_color = "#a6e3a1"
    text_color = "#cdd6f4"
    workspace_colors = [ "#cba6f7" ]

    [appearance.primary_color]
    base = "#cba6f7"
    text = "#1e1e2e"

    [appearance.danger_color]
    base = "#f38ba8"
    weak = "#f9e2af"

    [appearance.background_color]
    base = "#1e1e2e"
    weak = "#313244"
    strong = "#45475a"

    [appearance.secondary_color]
    base = "#11111b"
    strong = "#1b1b25"
  '';

  xdg.configFile."ashell/tasks.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env fish

      set count (task due.before:now status:pending count 2>/dev/null)
      echo $count
    '';
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_mocha";
      proc_sorting = "memory";
      proc_follow_detailed = true;
      show_disks = false;
      use_fstab = true;
      save_config_on_exit = false;
    };
  };

  xdg.configFile."btop/themes/catppuccin_mocha.theme".text = ''
    theme[main_bg]="#1e1e2e"
    theme[main_fg]="#cdd6f4"
    theme[title]="#cdd6f4"
    theme[hi_fg]="#89b4fa"
    theme[selected_bg]="#45475a"
    theme[selected_fg]="#89b4fa"
    theme[inactive_fg]="#7f849c"
    theme[graph_text]="#f5e0dc"
    theme[meter_bg]="#45475a"
    theme[proc_misc]="#f5e0dc"
    theme[cpu_box]="#cba6f7"
    theme[mem_box]="#a6e3a1"
    theme[net_box]="#eba0ac"
    theme[proc_box]="#89b4fa"
    theme[div_line]="#6c7086"
    theme[temp_start]="#a6e3a1"
    theme[temp_mid]="#f9e2af"
    theme[temp_end]="#f38ba8"
    theme[cpu_start]="#94e2d5"
    theme[cpu_mid]="#74c7ec"
    theme[cpu_end]="#b4befe"
    theme[free_start]="#cba6f7"
    theme[free_mid]="#b4befe"
    theme[free_end]="#89b4fa"
    theme[cached_start]="#74c7ec"
    theme[cached_mid]="#89b4fa"
    theme[cached_end]="#b4befe"
    theme[available_start]="#fab387"
    theme[available_mid]="#eba0ac"
    theme[available_end]="#f38ba8"
    theme[used_start]="#a6e3a1"
    theme[used_mid]="#94e2d5"
    theme[used_end]="#89dceb"
    theme[download_start]="#fab387"
    theme[download_mid]="#eba0ac"
    theme[download_end]="#f38ba8"
    theme[upload_start]="#a6e3a1"
    theme[upload_mid]="#94e2d5"
    theme[upload_end]="#89dceb"
    theme[process_start]="#74c7ec"
    theme[process_mid]="#b4befe"
    theme[process_end]="#cba6f7"
  '';

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

  programs.fish = {
    enable = true;
    plugins = [
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
    ];
    shellInit = ''
      set -gx EDITOR hx
    '';
    loginShellInit = ''
      if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec Hyprland
      end
    '';
    interactiveShellInit = ''
      zoxide init fish | source
      set -U tide_aws_bg_color normal
      set -U tide_aws_color FF9900
      set -U tide_aws_icon "\Uf270"
      set -U tide_bun_bg_color normal
      set -U tide_bun_color FBF0DF
      set -U tide_bun_icon "\U000f0cd3"
      set -U tide_character_color 5FD700
      set -U tide_character_color_failure FF0000
      set -U tide_character_icon "❯"
      set -U tide_character_vi_icon_default "❯"
      set -U tide_character_vi_icon_replace "▶"
      set -U tide_character_vi_icon_visual V
      set -U tide_cmd_duration_bg_color normal
      set -U tide_cmd_duration_color 87875F
      set -U tide_cmd_duration_decimals 0
      set -U tide_cmd_duration_icon ""
      set -U tide_cmd_duration_threshold 3000
      set -U tide_context_always_display false
      set -U tide_context_bg_color normal
      set -U tide_context_color_default D7AF87
      set -U tide_context_color_root D7AF00
      set -U tide_context_color_ssh D7AF87
      set -U tide_context_hostname_parts 1
      set -U tide_crystal_bg_color normal
      set -U tide_crystal_color FFFFFF
      set -U tide_crystal_icon ""
      set -U tide_direnv_bg_color normal
      set -U tide_direnv_bg_color_denied normal
      set -U tide_direnv_color D7AF00
      set -U tide_direnv_color_denied FF0000
      set -U tide_direnv_icon "▼"
      set -U tide_distrobox_bg_color normal
      set -U tide_distrobox_color FF00FF
      set -U tide_distrobox_icon "\U000f01a7"
      set -U tide_docker_bg_color normal
      set -U tide_docker_color 2496ED
      set -U tide_docker_default_contexts default colima
      set -U tide_docker_icon ""
      set -U tide_elixir_bg_color normal
      set -U tide_elixir_color 4E2A8E
      set -U tide_elixir_icon ""
      set -U tide_gcloud_bg_color normal
      set -U tide_gcloud_color 4285F4
      set -U tide_gcloud_icon "\U000f02ad"
      set -U tide_git_bg_color normal
      set -U tide_git_bg_color_unstable normal
      set -U tide_git_bg_color_urgent normal
      set -U tide_git_color_branch 5FD700
      set -U tide_git_color_conflicted FF0000
      set -U tide_git_color_dirty D7AF00
      set -U tide_git_color_operation FF0000
      set -U tide_git_color_staged D7AF00
      set -U tide_git_color_stash 5FD700
      set -U tide_git_color_untracked 00AFFF
      set -U tide_git_color_upstream 5FD700
      set -U tide_git_icon ""
      set -U tide_git_truncation_length 24
      set -U tide_git_truncation_strategy ""
      set -U tide_go_bg_color normal
      set -U tide_go_color 00ACD7
      set -U tide_go_icon ""
      set -U tide_java_bg_color normal
      set -U tide_java_color ED8B00
      set -U tide_java_icon ""
      set -U tide_jobs_bg_color normal
      set -U tide_jobs_color 5FAF00
      set -U tide_jobs_icon ""
      set -U tide_jobs_number_threshold 1000
      set -U tide_kubectl_bg_color normal
      set -U tide_kubectl_color 326CE5
      set -U tide_kubectl_icon "\U000f10fe"
      set -U tide_left_prompt_frame_enabled false
      set -U tide_left_prompt_items pwd git newline character
      set -U tide_left_prompt_prefix ""
      set -U tide_left_prompt_separator_diff_color " "
      set -U tide_left_prompt_separator_same_color " "
      set -U tide_left_prompt_suffix " "
      set -U tide_nix_shell_bg_color normal
      set -U tide_nix_shell_color 7EBAE4
      set -U tide_nix_shell_icon ""
      set -U tide_node_bg_color normal
      set -U tide_node_color 44883E
      set -U tide_node_icon ""
      set -U tide_os_bg_color normal
      set -U tide_os_color normal
      set -U tide_os_icon ""
      set -U tide_php_bg_color normal
      set -U tide_php_color 617CBE
      set -U tide_php_icon ""
      set -U tide_private_mode_bg_color normal
      set -U tide_private_mode_color FFFFFF
      set -U tide_private_mode_icon "\U000f05f9"
      set -U tide_prompt_add_newline_before true
      set -U tide_prompt_color_frame_and_connection 808080
      set -U tide_prompt_color_separator_same_color 949494
      set -U tide_prompt_icon_connection "─"
      set -U tide_prompt_min_cols 34
      set -U tide_prompt_pad_items false
      set -U tide_prompt_transient_enabled true
      set -U tide_pulumi_bg_color normal
      set -U tide_pulumi_color F7BF2A
      set -U tide_pulumi_icon ""
      set -U tide_pwd_bg_color normal
      set -U tide_pwd_color_anchors 00AFFF
      set -U tide_pwd_color_dirs 0087AF
      set -U tide_pwd_color_truncated_dirs 8787AF
      set -U tide_pwd_icon ""
      set -U tide_pwd_icon_home ""
      set -U tide_pwd_icon_unwritable ""
      set -U tide_pwd_markers .bzr .citc .git .hg .node-version .python-version .ruby-version .shorten_folder_marker .svn .terraform bun.lockb Cargo.toml composer.json CVS go.mod package.json build.zig
      set -U tide_python_bg_color normal
      set -U tide_python_color 00AFAF
      set -U tide_python_icon "\U000f0320"
      set -U tide_right_prompt_frame_enabled false
      set -U tide_right_prompt_items status cmd_duration context jobs direnv bun node python rustc java php pulumi ruby go gcloud kubectl distrobox toolbox terraform aws nix_shell crystal elixir zig
      set -U tide_right_prompt_prefix " "
      set -U tide_right_prompt_separator_diff_color " "
      set -U tide_right_prompt_separator_same_color " "
      set -U tide_right_prompt_suffix ""
      set -U tide_ruby_bg_color normal
      set -U tide_ruby_color B31209
      set -U tide_ruby_icon ""
      set -U tide_rustc_bg_color normal
      set -U tide_rustc_color F74C00
      set -U tide_rustc_icon ""
      set -U tide_shlvl_bg_color normal
      set -U tide_shlvl_color d78700
      set -U tide_shlvl_icon ""
      set -U tide_shlvl_threshold 1
      set -U tide_status_bg_color normal
      set -U tide_status_bg_color_failure normal
      set -U tide_status_color 5FAF00
      set -U tide_status_color_failure D70000
      set -U tide_status_icon "✔"
      set -U tide_status_icon_failure "✘"
      set -U tide_terraform_bg_color normal
      set -U tide_terraform_color 844FBA
      set -U tide_terraform_icon "\U000f1062"
      set -U tide_time_bg_color normal
      set -U tide_time_color 5F8787
      set -U tide_time_format ""
      set -U tide_toolbox_bg_color normal
      set -U tide_toolbox_color 613583
      set -U tide_toolbox_icon ""
      set -U tide_vi_mode_bg_color_default normal
      set -U tide_vi_mode_bg_color_insert normal
      set -U tide_vi_mode_bg_color_replace normal
      set -U tide_vi_mode_bg_color_visual normal
      set -U tide_vi_mode_color_default 949494
      set -U tide_vi_mode_color_insert 87AFAF
      set -U tide_vi_mode_color_replace 87AF87
      set -U tide_vi_mode_color_visual FF8700
      set -U tide_vi_mode_icon_default D
      set -U tide_vi_mode_icon_insert I
      set -U tide_vi_mode_icon_replace R
      set -U tide_vi_mode_icon_visual V
      set -U tide_zig_bg_color normal
      set -U tide_zig_color F7A41D
      set -U tide_zig_icon ""
    '';
    shellAbbrs = {
      ls = { expansion = "eza --icons"; position = "anywhere"; };
      cd = "z";
      cdi = "zi";
      cat = { expansion = "bat"; position = "anywhere"; };
      grep = { expansion = "rg"; position = "anywhere"; };
      find = { expansion = "fd"; position = "anywhere"; };
      mkdir = { expansion = "mkdir -p"; position = "anywhere"; };
      cp = { expansion = "cp -iv"; position = "anywhere"; };
      mv = { expansion = "mv -iv"; position = "anywhere"; };
      fetch = "catnap";
      sudo = "sudo -E";
    };
    functions = {
      reconfig = "sudo nixos-rebuild switch --flake github:meihapps/nix --refresh";
      fuck = "eval sudo -E $history[1]";
      "!!" = "eval $history[1]";
      hxnotes = ''
        set prev (pwd)
        cd ~/helix_notes
        hx (date +'%Y-%m-%d_%H-%M-%S').md
        cd $prev
      '';
    };
  };

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

  xdg.configFile."mimeapps.list".force = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/discord" = "vesktop.desktop";
      "x-scheme-handler/discord-455712169795780630" = "discord-455712169795780630.desktop";
      "image/png" = "com.github.aliencoweatcake.imageviewer.desktop";
      "application/pdf" = "firefox.desktop";
      "x-scheme-handler/mailto" = "userapp-Thunderbird-WVM8L3.desktop";
      "message/rfc822" = "userapp-Thunderbird-WVM8L3.desktop";
      "x-scheme-handler/mid" = "userapp-Thunderbird-WVM8L3.desktop";
      "x-scheme-handler/discord-409416265891971072" = "discord-409416265891971072.desktop";
      "x-scheme-handler/discord-742222376518811669" = "discord-742222376518811669.desktop";
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
      "application/x-zerosize" = "helix.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "application/zip" = "xarchiver.desktop";
      "image/gif" = "swayimg.desktop";
    };
    associations.added = {
      "image/jpeg" = [ "com.mitchellh.ghostty.desktop" ];
      "inode/directory" = [ "mpv.desktop" "swayimg.desktop" "com.mitchellh.ghostty.desktop" ];
      "application/x-fishscript" = [ "vim.desktop" ];
      "image/png" = [ "swayimg.desktop" "com.github.aliencoweatcake.imageviewer.desktop" ];
      "application/json" = [ "helix.desktop" ];
      "text/plain" = [ "helix.desktop" ];
      "application/vnd.microsoft.portable-executable" = [ "wine.desktop" ];
      "application/pdf" = [ "org.pwmt.zathura.desktop" "firefox.desktop" ];
      "x-scheme-handler/mailto" = [ "userapp-Thunderbird-WVM8L3.desktop" ];
      "x-scheme-handler/mid" = [ "userapp-Thunderbird-WVM8L3.desktop" ];
      "application/vnd.efi.iso" = [ "org.gnome.FileRoller.desktop" "gnome-disk-image-writer.desktop" ];
      "application/vnd.kde.kxmlguirc" = [ "helix.desktop" ];
      "image/svg+xml" = [ "firefox.desktop" "helix.desktop" ];
      "application/x-zerosize" = [ "swayimg.desktop" "helix.desktop" ];
      "application/zip" = [ "xarchiver.desktop" ];
      "image/gif" = [ "firefox.desktop" "swayimg.desktop" ];
    };
  };

  programs.mpv = {
    enable = true;
    config = {
      ytdl-format = "bestvideo[height<=2160]+bestaudio/best";
    };
  };

  xdg.configFile."mpv/script-opts/uosc.conf".text = ''
    color=foreground=CDD6F4,foreground_text=1E1E2E,background=1E1E2E,background_text=CDD6F4,curtain=11111B,success=A6E3A1,error=F38BA8
  '';

  programs.zathura = {
    enable = true;
    mappings = {
      "<Right>" = "navigate next";
      "<Left>" = "navigate previous";
    };
  };

  programs.lazygit.enable = true;

  programs.git = {
    enable = true;
    ignores = [ "**/.claude/settings.local.json" ];
    settings = {
      init.defaultBranch = "main";
      user = {
        name = "mei happs";
        email = "mail@meihapps.gay";
      };
    };
  };
  
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        color-modes = true;
        completion-replace = true;
        cursorline = true;
        end-of-line-diagnostics = "hint";
        rulers = [ 81 121 ];
        trim-final-newlines = true;
        trim-trailing-whitespace = true;
        auto-save = {
          focus-lost = true;
          after-delay = {
            enable = true;
            timeout = 300;
          };
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker.hidden = false;
        indent-guides = {
          character = "|";
          render = true;
        };
        inline-diagnostics.cursor-line = "warning";
        statusline = {
          center = [];
          left = [ "mode" "spinner" "version-control" "spacer" "separator" "file-name" "read-only-indicator" "file-modification-indicator" ];
          right = [ "diagnostics" "workspace-diagnostics" "position" "total-line-numbers" "position-percentage" "file-encoding" "file-line-ending" "file-type" "register" "selections" ];
          separator = "|";
        };
      };
      keys.normal.G = {
        P = "@:sh git push<ret>";
        c = ''@:sh git commit -a -m ""<left>'';
        p = "@:sh git pull<ret>";
        x = "@ /=======";
      };
    };
    languages = {
      language-server = {
        harper-ls = {
          command = "harper-ls";
          args = [ "--stdio" ];
        };
        typos-lsp.command = "typos-lsp";
      };
      language = [
        {
          name = "python";
          language-servers = [ "basedpyright" "typos-lsp" ];
          formatter = { command = "ruff"; args = [ "format" "-" ]; };
          auto-format = true;
        }
        {
          name = "rust";
          language-servers = [ "rust-analyzer" "typos-lsp" ];
          formatter = { command = "rustfmt"; };
          auto-format = true;
        }
        {
          name = "typescript";
          language-servers = [ "typescript-language-server" "typos-lsp" ];
          formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; };
          auto-format = true;
        }
        {
          name = "markdown";
          language-servers = [ "harper-ls" "typos-lsp" ];
        }
      ];
    };
  };


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

  xdg.configFile."hypr/mocha.conf".text = ''
    $rosewater = rgb(f5e0dc)
    $rosewaterAlpha = f5e0dc
    $flamingo = rgb(f2cdcd)
    $flamingoAlpha = f2cdcd
    $pink = rgb(f5c2e7)
    $pinkAlpha = f5c2e7
    $mauve = rgb(cba6f7)
    $mauveAlpha = cba6f7
    $red = rgb(f38ba8)
    $redAlpha = f38ba8
    $maroon = rgb(eba0ac)
    $maroonAlpha = eba0ac
    $peach = rgb(fab387)
    $peachAlpha = fab387
    $yellow = rgb(f9e2af)
    $yellowAlpha = f9e2af
    $green = rgb(a6e3a1)
    $greenAlpha = a6e3a1
    $teal = rgb(94e2d5)
    $tealAlpha = 94e2d5
    $sky = rgb(89dceb)
    $skyAlpha = 89dceb
    $sapphire = rgb(74c7ec)
    $sapphireAlpha = 74c7ec
    $blue = rgb(89b4fa)
    $blueAlpha = 89b4fa
    $lavender = rgb(b4befe)
    $lavenderAlpha = b4befe
    $text = rgb(cdd6f4)
    $textAlpha = cdd6f4
    $subtext1 = rgb(bac2de)
    $subtext1Alpha = bac2de
    $subtext0 = rgb(a6adc8)
    $subtext0Alpha = a6adc8
    $overlay2 = rgb(9399b2)
    $overlay2Alpha = 9399b2
    $overlay1 = rgb(7f849c)
    $overlay1Alpha = 7f849c
    $overlay0 = rgb(6c7086)
    $overlay0Alpha = 6c7086
    $surface2 = rgb(585b70)
    $surface2Alpha = 585b70
    $surface1 = rgb(45475a)
    $surface1Alpha = 45475a
    $surface0 = rgb(313244)
    $surface0Alpha = 313244
    $base = rgb(1e1e2e)
    $baseAlpha = 1e1e2e
    $mantle = rgb(181825)
    $mantleAlpha = 181825
    $crust = rgb(11111b)
    $crustAlpha = 11111b
  '';

  xdg.configFile."hypr/hyprlock.conf".text = ''
    source = $HOME/.config/hypr/mocha.conf

    $accent = $mauve
    $accentAlpha = $mauveAlpha
    $font = FiraMono Nerd Font

    general {
      hide_cursor = true
    }

    background {
      monitor =
      path = $HOME/.config/hypr/background.png
      blur_passes = 0
      color = $base
    }

    label {
      monitor =
      text = Layout: $LAYOUT
      color = $text
      font_size = 25
      font_family = $font
      position = 30, -30
      halign = left
      valign = top
    }

    label {
      monitor =
      text = $TIME
      color = $text
      font_size = 90
      font_family = $font
      position = -30, 0
      halign = right
      valign = top
    }

    label {
      monitor =
      text = cmd[update:43200000] date +"%A, %d %B %Y"
      color = $text
      font_size = 25
      font_family = $font
      position = -30, -150
      halign = right
      valign = top
    }

    image {
      monitor =
      path = $HOME/.face
      size = 100
      border_color = $accent
      position = 0, 75
      halign = center
      valign = center
    }

    input-field {
      monitor =
      size = 300, 60
      outline_thickness = 4
      dots_size = 0.2
      dots_spacing = 0.2
      dots_center = true
      outer_color = $accent
      inner_color = $surface0
      font_color = $text
      fade_on_empty = false
      placeholder_text = <span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>
      hide_input = false
      check_color = $accent
      fail_color = $red
      fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
      capslock_color = $yellow
      position = 0, -47
      halign = center
      valign = center
    }
  '';

  xdg.configFile."hypr/background.png".source = ./background.png;

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    splash = false
    preload = ~/.config/hypr/background.png

    wallpaper {
        monitor =
        path = ~/.config/hypr/background.png
        fit_mode = contain
    }
  '';
}
