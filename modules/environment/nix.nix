{ inputs, ... }:
{
  nix = {
    # lets this flake be referenced as mei#<output>, e.g. nix flake init -t mei#rust
    registry.mei.flake = inputs.self;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
    };
  };
  nixpkgs.config.allowUnfree = true;
}
