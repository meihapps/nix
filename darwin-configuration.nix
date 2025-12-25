{ ... }:

{
  imports = [
    ./modules/languages
    ./modules/homebrew.nix
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
