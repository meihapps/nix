{ pkgs, ... }:
{
  imports = [
    ./generic.nix
    ./rust
    ./python
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
