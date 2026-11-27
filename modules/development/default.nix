{ pkgs, ... }:
{
  imports = [
    ./nix
    ./php
    ./python
    ./qml
    ./rust
    ./typescript
  ];

  environment.systemPackages = with pkgs; [
    claude-code
    google-chrome
    jujutsu
  ];

  home-manager.users.mei.programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      wayland
      libxkbcommon
      libGL
    ];
  };
}
