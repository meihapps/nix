{ ... }:

{
  # Since Ghostty is not available in nixpkgs for macOS yet,
  # we'll just manage the configuration file directly
  home.file.".config/ghostty/config".text = ''
    font-family = Fira Code
    font-size = 16
    theme = light:Catppuccin Latte,dark:Catppuccin Mocha
    cursor-style = bar
    macos-icon = xray
  '';
}
