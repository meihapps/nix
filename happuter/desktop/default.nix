{ ... }:
{
  imports = [
    ../../modules/environment
    ../../modules/environment/rust.nix
    ./bar.nix
    ./gtk.nix
    ./launcher.nix
    ./media.nix
    ./mimeapps.nix
    ./monitoring.nix
    ./notifications.nix
    ./packages.nix
    ./pdf.nix
    ./terminal.nix
    ./wm
  ];

}
