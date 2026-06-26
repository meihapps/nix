{ pkgs, lib, ... }:
{
  programs.fish = {
    functions = {
      task.body = "ssh happvps task $argv";
    };
    shellInit = ''
      set -gx LD_LIBRARY_PATH ${lib.makeLibraryPath (with pkgs; [
        wayland
        libxkbcommon
        vulkan-loader
        libGL
      ])}
    '';
    loginShellInit = ''
      if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec start-hyprland
      end
    '';
  };
}
