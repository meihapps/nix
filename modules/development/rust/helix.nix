{ ... }:
{
  programs.helix.languages = {
    language-server.typos-lsp.command = "typos-lsp";
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
