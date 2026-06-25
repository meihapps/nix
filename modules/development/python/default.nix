{ pkgs, ... }:
{
  home-manager.users.mei.home.packages = with pkgs; [ python3 uv ];

  home-manager.users.mei.programs.helix.languages.language = [
    {
      name = "python";
      language-servers = [ "basedpyright" "typos-lsp" ];
      formatter = { command = "ruff"; args = [ "format" "-" ]; };
      auto-format = true;
    }
  ];
}
