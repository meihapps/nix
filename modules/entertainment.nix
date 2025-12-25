{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # discord
    prismlauncher
    # steam
    vlc-bin
  ];

  # homebrew.casks = [
  #   "crossover"
  # ];
}
