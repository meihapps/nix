{ pkgs, ... }:
{
  home-manager.users.mei.home.packages = with pkgs; [
    nodejs
    typescript-language-server
    prettier
  ];

  home-manager.users.mei.programs.helix.languages.language = [
    {
      name = "typescript";
      language-servers = [ "typescript-language-server" "typos-lsp" ];
      formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; };
      auto-format = true;
    }
  ];
}
