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
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

outputs = inputs@{ self, agenix, caelestia-shell, chaotic, disko, home-manager, nixpkgs, zen-browser, ... }:
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

    devShells.x86_64-linux.playwright =
      let pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in pkgs.mkShell {
        packages = [ pkgs.nodejs pkgs.playwright-driver.browsers ];
        PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
        PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
      };

    templates = {
      rust = {
        path = ./templates/rust;
        description = "Rust dev shell with toolchain from rust-toolchain.toml";
      };
      rust-wasm = {
        path = ./templates/rust-wasm;
        description = "Rust wasm dev shell with trunk and the wasm32 target";
      };
    };
  };
}
