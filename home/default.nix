{ ... }:
{
  imports = [
    ./bar.nix
    ./rust.nix
    ./dolphin-emu.nix
    ./editor.nix
    ./fetch.nix
    ./git.nix
    ./gtk.nix
    ./launcher.nix
    ./media.nix
    ./mimeapps.nix
    ./monitoring.nix
    ./notifications.nix
    ./packages.nix
    ./pdf.nix
    ./shell.nix
    ./terminal.nix
    ./wm
  ];

  home.stateVersion = "26.05";
}
