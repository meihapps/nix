{ lib, ... }:
{
  programs.fish.functions.reconfig = lib.mkForce {
    body = ''
      argparse 'a/amend' -- $argv

      git -C /etc/nixos add .

      if set -q _flag_amend
        git -C /etc/nixos commit --amend -a
        git -C /etc/nixos push --force
      else
        git -C /etc/nixos commit -a
        git -C /etc/nixos push
      end

      sudo nixos-rebuild switch --flake github:meihapps/nix#happuter --refresh
      notify-send "reconfig" "done"
    '';
  };
}
