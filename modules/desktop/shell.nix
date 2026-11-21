{ pkgs, lib, ... }:
{
  programs.fish = {
    shellInit = ''
      set -gx LD_LIBRARY_PATH ${lib.makeLibraryPath (with pkgs; [
        wayland
        libxkbcommon
        vulkan-loader
        libGL
      ])}
    '';
  };
}
