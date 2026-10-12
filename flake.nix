{
  inputs = {
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llama-cpp = {
        url = "github:ggml-org/llama.cpp";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    rtl88x2bu = {
      url = "github:Sam23656/Rtl88x2bu-NixOS-Driver";
      flake = false;
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

outputs = inputs@{ self, agenix, caelestia-shell, chaotic, disko, home-manager, nixpkgs, rtl88x2bu, zen-browser, ... }:
let
  remoteHostsFor = name: builtins.filter (h: h != name) (builtins.attrNames self.nixosConfigurations);
  remoteHosts = remoteHostsFor "happuter";
in
  {
    nixosConfigurations.happuter = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs remoteHosts; };
      modules = [
        agenix.nixosModules.default
        chaotic.nixosModules.nyx-cache
        chaotic.nixosModules.nyx-overlay
        chaotic.nixosModules.nyx-registry
        ./devices/happuter
        home-manager.nixosModules.home-manager
      ];
    };

    nixosConfigurations.happtop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        agenix.nixosModules.default
        chaotic.nixosModules.nyx-cache
        chaotic.nixosModules.nyx-overlay
        chaotic.nixosModules.nyx-registry
        ./devices/happtop
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
