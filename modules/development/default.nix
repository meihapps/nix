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
    jujutsu
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      wayland
      libxkbcommon
      libGL
    ];
  };
}
