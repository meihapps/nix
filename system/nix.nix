{ ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.build-dir = "/mnt/happssd/nix-builds";
  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}
