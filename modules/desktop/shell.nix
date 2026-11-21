{ pkgs, lib, ... }:
{
  programs.fish = {
    functions = {
      task.body = "ssh happserver task $argv";
    };
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
