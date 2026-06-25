{ pkgs, lib, ... }:
{
  imports = [
    ./boot.nix
    ./nix.nix
    ./ssh.nix
    ./tailscale.nix
    ./users.nix
  ];

  programs.fish.enable = true;

  time.timeZone = lib.mkDefault "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  programs.ssh.startAgent = true;

  environment.systemPackages = [ pkgs.helix ];

  services.fwupd.enable = true;

  home-manager.users.mei = {};

  home-manager.sharedModules = [{
    imports = [
      ./editor.nix
      ./fetch.nix
      ./git.nix
      ./ghostty.nix
      ./packages.nix
      ./shell.nix
    ];
    home.stateVersion = "26.05";
  }];
}
