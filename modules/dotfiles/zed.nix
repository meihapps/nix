{ ... }:

{
  home.file.".config/zed/settings.json" = {
    text = builtins.toJSON {
      show_edit_predictions = false;
      agent = {
        dock = "right";
        default_model = {
          provider = "copilot_chat";
          model = "claude-sonnet-4";
        };
        model_parameters = [];
        always_allow_tool_actions = true;
      };
      ui_font_family = "Fira Sans";
      ui_font_size = 16;
      buffer_font_size = 16;
      buffer_font_family = "Fira Code";
      theme = {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };
      autosave = {
        after_delay = {
          milliseconds = 300;
        };
      };
      restore_on_startup = "none";
      format_on_save = "on";
      soft_wrap = "editor_width";
      wrap_guides = [80];
      telemetry = {
        diagnostics = true;
        metrics = true;
      };
      file_types = {
        JSON = ["*.json" "*.jsonld"];
      };
      lsp = {
        tinymist = {
          initialization_options = {
            preview = {
              background = {
                enabled = true;
              };
            };
          };
        };
        nil = {
          binary = {
            path = "/Users/meihapps/.nix-profile/bin/nil";
          };
          initialization_options = {
            autoArchive = true;
          };
        };
        nixd = {
          binary = {
            path = "/Users/meihapps/.nix-profile/bin/nixd";
          };
        };
      };
    };
  };
}
