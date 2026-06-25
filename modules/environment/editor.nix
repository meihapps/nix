{ ... }:
{
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
          name = "markdown";
          language-servers = [ "harper-ls" "typos-lsp" ];
        }
      ];
    };
  };
}
