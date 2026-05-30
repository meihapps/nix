{
  inputs = {
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    chaotic.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = inputs@{ self, chaotic, home-manager, hyprland, nixpkgs, ... }: {
    nixosConfigurations.happuter = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        { nixpkgs.overlays = [ chaotic.overlays.cache-friendly ]; }
        chaotic.nixosModules.nyx-cache
        ./boot.nix
        ./desktop.nix
        ./hardware.nix
        ./hardware-configuration.nix
        ./home-manager.nix
        ./networking.nix
        ./nix.nix
        ./packages.nix
        ./users.nix
        home-manager.nixosModules.home-manager
      ];
    };
  };
}

