{ pkgs, lib, remoteHosts, ... }:
{
  programs.fish.functions.reconfig = {
    body = let
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
}
