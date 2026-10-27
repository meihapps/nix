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

  programs.fish.functions.new-proj = {
    description = "Create a new jj + nix flake + direnv project";
    body = ''
      if test (count $argv) -lt 1; or test (count $argv) -gt 2
          echo "usage: new-proj <name> [<nix flake template>]" >&2
          return 1
      end

      set -l name $argv[1]
      set -l template templates#default
      if test (count $argv) -eq 2
          set template $argv[2]
      end

      cd /mnt/happssd/projects; or return
      if test -e $name
          echo "new-proj: $name already exists" >&2
          return 1
      end

      nix flake new $name -t $template; or return
      cd $name; or return

      jj git init --colocate; or return

      # direnv setup, unless the template already provided it
      if not test -e .envrc
          echo "use flake" > .envrc
      end
      if not grep -qxF .direnv/ .gitignore 2>/dev/null
          echo .direnv/ >> .gitignore
      end

      # let nix see the new files without committing them
      git add -N .

      direnv allow
    '';
  };
}
