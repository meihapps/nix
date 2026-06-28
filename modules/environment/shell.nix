{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    plugins = [
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
    ];
    shellInit = ''
      set -gx EDITOR hx
      fish_add_path ~/.cargo/bin ~/.local/bin
    '';
    interactiveShellInit = ''
      zoxide init fish | source
      set -U tide_aws_bg_color normal
      set -U tide_aws_color FAB387
      set -U tide_aws_icon "\Uf270"
      set -U tide_bun_bg_color normal
      set -U tide_bun_color F5E0DC
      set -U tide_bun_icon "\U000f0cd3"
      set -U tide_character_color CBA6F7
      set -U tide_character_color_failure F38BA8
      set -U tide_character_icon "❯"
      set -U tide_character_vi_icon_default "❯"
      set -U tide_character_vi_icon_replace "▶"
      set -U tide_character_vi_icon_visual V
      set -U tide_cmd_duration_bg_color normal
      set -U tide_cmd_duration_color 9399B2
      set -U tide_cmd_duration_decimals 0
      set -U tide_cmd_duration_icon ""
      set -U tide_cmd_duration_threshold 3000
      set -U tide_context_always_display false
      set -U tide_context_bg_color normal
      set -U tide_context_color_default BAC2DE
      set -U tide_context_color_root F38BA8
      set -U tide_context_color_ssh A6E3A1
      set -U tide_context_hostname_parts 1
      set -U tide_crystal_bg_color normal
      set -U tide_crystal_color CDD6F4
      set -U tide_crystal_icon ""
      set -U tide_direnv_bg_color normal
      set -U tide_direnv_bg_color_denied normal
      set -U tide_direnv_color F9E2AF
      set -U tide_direnv_color_denied F38BA8
      set -U tide_direnv_icon "▼"
      set -U tide_distrobox_bg_color normal
      set -U tide_distrobox_color F5C2E7
      set -U tide_distrobox_icon "\U000f01a7"
      set -U tide_docker_bg_color normal
      set -U tide_docker_color 89B4FA
      set -U tide_docker_default_contexts default colima
      set -U tide_docker_icon ""
      set -U tide_elixir_bg_color normal
      set -U tide_elixir_color CBA6F7
      set -U tide_elixir_icon ""
      set -U tide_gcloud_bg_color normal
      set -U tide_gcloud_color 89B4FA
      set -U tide_gcloud_icon "\U000f02ad"
      set -U tide_git_bg_color normal
      set -U tide_git_bg_color_unstable normal
      set -U tide_git_bg_color_urgent normal
      set -U tide_git_color_branch A6E3A1
      set -U tide_git_color_conflicted F38BA8
      set -U tide_git_color_dirty F9E2AF
      set -U tide_git_color_operation F38BA8
      set -U tide_git_color_staged FAB387
      set -U tide_git_color_stash 94E2D5
      set -U tide_git_color_untracked 89DCEB
      set -U tide_git_color_upstream 74C7EC
      set -U tide_git_icon ""
      set -U tide_git_truncation_length 24
      set -U tide_git_truncation_strategy ""
      set -U tide_go_bg_color normal
      set -U tide_go_color 89DCEB
      set -U tide_go_icon ""
      set -U tide_java_bg_color normal
      set -U tide_java_color FAB387
      set -U tide_java_icon ""
      set -U tide_jobs_bg_color normal
      set -U tide_jobs_color 94E2D5
      set -U tide_jobs_icon ""
      set -U tide_jobs_number_threshold 1000
      set -U tide_kubectl_bg_color normal
      set -U tide_kubectl_color 89B4FA
      set -U tide_kubectl_icon "\U000f10fe"
      set -U tide_left_prompt_frame_enabled false
      set -U tide_left_prompt_items pwd git newline character
      set -U tide_left_prompt_prefix ""
      set -U tide_left_prompt_separator_diff_color " "
      set -U tide_left_prompt_separator_same_color " "
      set -U tide_left_prompt_suffix " "
      set -U tide_nix_shell_bg_color normal
      set -U tide_nix_shell_color 89B4FA
      set -U tide_nix_shell_icon ""
      set -U tide_node_bg_color normal
      set -U tide_node_color A6E3A1
      set -U tide_node_icon ""
      set -U tide_os_bg_color normal
      set -U tide_os_color normal
      set -U tide_os_icon ""
      set -U tide_php_bg_color normal
      set -U tide_php_color B4BEFE
      set -U tide_php_icon ""
      set -U tide_private_mode_bg_color normal
      set -U tide_private_mode_color CDD6F4
      set -U tide_private_mode_icon "\U000f05f9"
      set -U tide_prompt_add_newline_before true
      set -U tide_prompt_color_frame_and_connection 6C7086
      set -U tide_prompt_color_separator_same_color 585B70
      set -U tide_prompt_icon_connection "─"
      set -U tide_prompt_min_cols 34
      set -U tide_prompt_pad_items false
      set -U tide_prompt_transient_enabled true
      set -U tide_pulumi_bg_color normal
      set -U tide_pulumi_color F9E2AF
      set -U tide_pulumi_icon ""
      set -U tide_pwd_bg_color normal
      set -U tide_pwd_color_anchors 89B4FA
      set -U tide_pwd_color_dirs B4BEFE
      set -U tide_pwd_color_truncated_dirs 9399B2
      set -U tide_pwd_icon ""
      set -U tide_pwd_icon_home ""
      set -U tide_pwd_icon_unwritable ""
      set -U tide_pwd_markers .bzr .citc .git .hg .node-version .python-version .ruby-version .shorten_folder_marker .svn .terraform bun.lockb Cargo.toml composer.json CVS go.mod package.json build.zig
      set -U tide_python_bg_color normal
      set -U tide_python_color F9E2AF
      set -U tide_python_icon "\U000f0320"
      set -U tide_right_prompt_frame_enabled false
      set -U tide_right_prompt_items status cmd_duration context jobs direnv bun node python rustc java php pulumi ruby go gcloud kubectl distrobox toolbox terraform aws nix_shell crystal elixir zig
      set -U tide_right_prompt_prefix " "
      set -U tide_right_prompt_separator_diff_color " "
      set -U tide_right_prompt_separator_same_color " "
      set -U tide_right_prompt_suffix ""
      set -U tide_ruby_bg_color normal
      set -U tide_ruby_color F38BA8
      set -U tide_ruby_icon ""
      set -U tide_rustc_bg_color normal
      set -U tide_rustc_color FAB387
      set -U tide_rustc_icon ""
      set -U tide_shlvl_bg_color normal
      set -U tide_shlvl_color F9E2AF
      set -U tide_shlvl_icon ""
      set -U tide_shlvl_threshold 1
      set -U tide_status_bg_color normal
      set -U tide_status_bg_color_failure normal
      set -U tide_status_color A6E3A1
      set -U tide_status_color_failure F38BA8
      set -U tide_status_icon "✔"
      set -U tide_status_icon_failure "✘"
      set -U tide_terraform_bg_color normal
      set -U tide_terraform_color CBA6F7
      set -U tide_terraform_icon "\U000f1062"
      set -U tide_time_bg_color normal
      set -U tide_time_color 9399B2
      set -U tide_time_format ""
      set -U tide_toolbox_bg_color normal
      set -U tide_toolbox_color CBA6F7
      set -U tide_toolbox_icon ""
      set -U tide_vi_mode_bg_color_default normal
      set -U tide_vi_mode_bg_color_insert normal
      set -U tide_vi_mode_bg_color_replace normal
      set -U tide_vi_mode_bg_color_visual normal
      set -U tide_vi_mode_color_default 9399B2
      set -U tide_vi_mode_color_insert 94E2D5
      set -U tide_vi_mode_color_replace F9E2AF
      set -U tide_vi_mode_color_visual FAB387
      set -U tide_vi_mode_icon_default D
      set -U tide_vi_mode_icon_insert I
      set -U tide_vi_mode_icon_replace R
      set -U tide_vi_mode_icon_visual V
      set -U tide_zig_bg_color normal
      set -U tide_zig_color FAB387
      set -U tide_zig_icon ""
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
      _tide_item_context.body = ''
        if set -q SSH_TTY
          set -fx tide_context_color A6E3A1
          string match -qr "^(?<h>(\.?[^\.]*){0,$tide_context_hostname_parts})" @$hostname
          set -l host_part (set_color CBA6F7)$h
          _tide_print_item context $USER$host_part
        else if test "$EUID" = 0
          set -fx tide_context_color $tide_context_color_root
          string match -qr "^(?<h>(\.?[^\.]*){0,$tide_context_hostname_parts})" @$hostname
          _tide_print_item context $USER$h
        else if test "$tide_context_always_display" = true
          set -fx tide_context_color $tide_context_color_default
          string match -qr "^(?<h>(\.?[^\.]*){0,$tide_context_hostname_parts})" @$hostname
          _tide_print_item context $USER$h
        else
          return
        end
      '';
      reconfig.body = ''
        sudo nixos-rebuild switch --flake github:meihapps/nix --refresh
      '';
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
}
