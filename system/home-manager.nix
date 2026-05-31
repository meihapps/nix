{ inputs, ... }:
{
  home-manager = {
    users.mei = import ../home;
    users.root = import ../home;
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
