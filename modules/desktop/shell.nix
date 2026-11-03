{ pkgs, lib, ... }:
{
  programs.fish = {
    functions = {
      task.body = "ssh happserver task $argv";
    };
    loginShellInit = ''
      if status is-login
          if uwsm check may-start; and uwsm select
              exec uwsm start default
          end
      end
    '';
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
