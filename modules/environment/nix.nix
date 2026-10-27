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
    };
  };
  nixpkgs.config.allowUnfree = true;
}
