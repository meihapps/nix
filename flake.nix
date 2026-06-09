{
  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    chaotic.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rtl88x2bu = {
      url = "github:Sam23656/Rtl88x2bu-NixOS-Driver";
      flake = false;
    };
  };
  outputs = inputs@{ self, agenix, chaotic, home-manager, hyprland, nixpkgs, rtl88x2bu, ... }: {
    nixosConfigurations.happuter = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        { nixpkgs.overlays = [ chaotic.overlays.cache-friendly ]; }
        agenix.nixosModules.default
        chaotic.nixosModules.nyx-cache
        ./system
        home-manager.nixosModules.home-manager
      ];
    };
  };
}

