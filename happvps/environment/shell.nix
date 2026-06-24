{ ... }:
{
  programs.fish.functions.reconfig.body = ''
    sudo nixos-rebuild switch --flake github:meihapps/nix --refresh
  '';
}
