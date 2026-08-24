{ pkgs, ... }:
{
  imports = [
    ./nix
    ./php
    ./python
    ./rust
    ./typescript
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
