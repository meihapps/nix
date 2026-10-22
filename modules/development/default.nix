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
