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
    disko = {
      url = "github:nix-community/disko";
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
outputs = inputs@{ self, agenix, chaotic, disko, home-manager, hyprland, nixpkgs, rtl88x2bu, ... }:
let
  remoteHosts = builtins.filter (h: h != "happuter") (builtins.attrNames self.nixosConfigurations);
in
  {
    nixosConfigurations.happuter = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs remoteHosts; };
      modules = [
        { nixpkgs.overlays = [ chaotic.overlays.cache-friendly ]; }
        agenix.nixosModules.default
        chaotic.nixosModules.nyx-cache
        ./devices/happuter
        home-manager.nixosModules.home-manager
      ];
    };

    nixosConfigurations.happvps = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        agenix.nixosModules.default
        disko.nixosModules.disko
        ./devices/happvps
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
