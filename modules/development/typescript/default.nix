{ pkgs, ... }:
{
  home-manager.users.mei.home.packages = with pkgs; [
    nodejs
    chromium
    playwright-driver.browsers
  ];

  environment.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };

  home-manager.users.mei.programs.helix.languages.language = [
    {
      name = "typescript";
      language-servers = [ "typescript-language-server" "typos-lsp" ];
      formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; };
      auto-format = true;
    }
  ];
}
