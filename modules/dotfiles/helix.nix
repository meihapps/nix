{ ... }:

{
  programs.helix = {
    enable = true;

    settings = {
      theme = "catppuccin_mocha";

      editor = {
        cursorline = true;
        color-modes = true;
        completion-replace = true;
        end-of-line-diagnostics = "hint";
        rulers = [81 121];
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

        file-picker = {
          hidden = false;
        };

        indent-guides = {
          render = true;
          character = "|";
        };

        inline-diagnostics = {
          cursor-line = "warning";
        };

        statusline = {
          left = [
            "mode"
            "spinner"
            "version-control"
            "spacer"
            "separator"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          center = [];
          right = [
            "diagnostics"
            "workspace-diagnostics"
            "position"
            "total-line-numbers"
            "position-percentage"
            "file-encoding"
            "file-line-ending"
            "file-type"
            "register"
            "selections"
          ];
          separator = "|";
        };
      };

      keys.normal = {
        "C-g" = [
          ":write-all"
          ":new"
          ":insert-output lazygit"
          ":set mouse false"
          ":set mouse true"
          ":buffer-close!"
          ":redraw"
          ":reload-all"
        ];

        G = {
          c = "@:sh git commit -a -m \"\"<left>";
          P = "@:sh git push <ret>";
          p = "@:sh git pull <ret>";
        };
      };
    };

    languages = {
      language-server.rust-analyzer.config = {
        check.command = "clippy";
      };

      language = [
        {
          name = "markdown";
          scope = "source.md";
          injection-regex = "md|markdown";
          file-types = ["md" "markdown" "PULLREQ_EDITMSG" "mkd" "mdwn" "mdown" "markdn" "mdtxt" "mdtext" "workbook"];
          roots = [".marksman.toml"];
          language-servers = ["marksman"];
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          soft-wrap.enable = true;
        }
        {
          name = "python";
          language-servers = ["basedpyright"];
          formatter = {
            command = "ruff";
            args = ["format" "--line-length" "88" "-"];
          };
        }
      ];
    };
  };
}
