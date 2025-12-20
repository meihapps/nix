{ ... }:

{
  imports = [
    ./modules/development.nix
    ./modules/entertainment.nix
    ./modules/languages
    ./modules/productivity.nix
    ./modules/shell-ecosystem.nix
    ./modules/shell-tools.nix
    ./modules/web.nix
  ];

  nix.enable = false;
  system.primaryUser = "meihapps";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };

  users.users.meihapps = {
    name = "meihapps";
    home = "/Users/meihapps";
  };

  system.stateVersion = 5;
}
