{ pkgs, lib, inputs, ... }:
{
  age.secrets.cargo-token = {
    file = ../secrets/cargo-token.age;
    owner = "mei";
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      wayland
      libxkbcommon
      libGL
    ];
  };

  programs.steam.enable = true;
  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    helix
    firefox
    gcc
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    jdk21
    prismlauncher
    rocmPackages.rocm-smi
    rustup
  ];


  fonts.packages = with pkgs; [
    fira-code
    nerd-fonts.fira-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
