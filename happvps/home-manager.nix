{ ... }:
{
  home-manager = {
    users.mei = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
