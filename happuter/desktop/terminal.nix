{ pkgs, lib, remoteHosts, ... }:
{
  dconf.settings."org/gnome/desktop/interface".gtk-enable-primary-paste = true;

  programs.fish = {
    functions.reconfig = {
      body =
        let
          rebuildBlock = host: cmd: ''
            printf '%-12s' '${host}'
            set tmpfile (mktemp)
            ${cmd} >$tmpfile 2>&1
            if test $status -ne 0
              echo FAILED
            else
              set warns (grep -ic warn $tmpfile 2>/dev/null)
              if test "$warns" -gt 0 2>/dev/null
                echo "ok ($warns warnings)"
              else
                echo ok
              end
            end
            rm -f $tmpfile
          '';
          localRebuild = "sudo -v\n" +
            rebuildBlock "happuter" "sudo nixos-rebuild switch --flake github:meihapps/nix --refresh";
          remoteRebuilds = lib.concatMapStringsSep "\n"
            (host: rebuildBlock host "ssh ${host} sudo nixos-rebuild switch --flake github:meihapps/nix --refresh")
            remoteHosts;
        in ''
          argparse 'a/amend' -- $argv

          git -C /etc/nixos add .

          if set -q _flag_amend
            git -C /etc/nixos commit --amend -a
            git -C /etc/nixos push --force
          else
            git -C /etc/nixos commit -a
            git -C /etc/nixos push
          end

          ${localRebuild}
          ${remoteRebuilds}
        '';
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

  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "Fira Code";
      font-size = 12;
      theme = "Catppuccin Mocha";
      palette = [
        "5=#cba6f7"
        "13=#cba6f7"
      ];
    };
  };
}
