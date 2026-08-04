{ ... }:
{
  programs.helix.languages = {
    language-server = {
      rust-analyzer.config.check = {
        command = "clippy";
        extraArgs = [
          "--"
          "-W" "clippy::all"
          "-W" "clippy::pedantic"
        ];
      };
      typos-lsp.command = "typos-lsp";
    };
    language = [
      {
        name = "rust";
        language-servers = [ "rust-analyzer" "typos-lsp" ];
        formatter = { command = "rustfmt"; };
        auto-format = true;
      }
    ];
  };
}
