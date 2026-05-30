{ inputs, ... }:
{
  home-manager = {
    users.mei = import ./home.nix;
    users.root = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
