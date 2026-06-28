{ pkgs, ... }:
{
  imports = [
    ./generic.nix
    ./rust
    ./python
    ./typescript
    ./php
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
