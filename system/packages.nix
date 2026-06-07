{ pkgs, lib, ... }:
{
  programs.steam.enable = true;
  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    helix
    firefox
    jdk21
    prismlauncher
    rocmPackages.rocm-smi
  ];

  environment.variables.LD_LIBRARY_PATH = [ "${pkgs.rocmPackages.rocm-smi}/lib" ];

  fonts.packages = with pkgs; [
    fira-code
    nerd-fonts.fira-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
