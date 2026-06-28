{ pkgs, ... }:
{
  home-manager.users.mei.home.packages = with pkgs; [
    php
    phpactor
    symfony-cli
  ];

  home-manager.users.mei.programs.helix.languages.language = [
    {
      name = "php";
      language-servers = [ "phpactor" ];
    }
  ];

  home-manager.users.mei.programs.helix.languages.language-server.phpactor = {
    command = "phpactor";
    args = [ "language-server" ];
  };
}
