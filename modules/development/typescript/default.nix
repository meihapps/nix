{ ... }:
{
  home-manager.users.mei.programs.helix.languages.language = [
    {
      name = "typescript";
      language-servers = [ "typescript-language-server" "typos-lsp" ];
      formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; };
      auto-format = true;
    }
  ];
}
