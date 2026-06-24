{ inputs, remoteHosts, ... }:
{
  home-manager = {
    users.mei = import ./desktop;
    users.root = import ./desktop;
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit remoteHosts; };
  };
}
