{
  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/65484713d962e7f1ddd42ce5012350b3b0298552";
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
    nixpkgs.url = "github:NixOS/nixpkgs/a799d3e3886da994fa307f817a6bc705ae538eeb";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    rtl88x2bu = {
      url = "github:Sam23656/Rtl88x2bu-NixOS-Driver";
      flake = false;
    };
  };

outputs = inputs@{ self, agenix, chaotic, disko, home-manager, hyprland, nixpkgs, rtl88x2bu, zen-browser, ... }:
let
  remoteHostsFor = name: builtins.filter (h: h != name) (builtins.attrNames self.nixosConfigurations);
  remoteHosts = remoteHostsFor "happuter";
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

    nixosConfigurations.happtop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        { nixpkgs.overlays = [ chaotic.overlays.cache-friendly ]; }
        agenix.nixosModules.default
        chaotic.nixosModules.nyx-cache
        ./devices/happtop
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

    homeConfigurations."mei@happi" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-linux;
      extraSpecialArgs = { inherit inputs; };
      modules = [ ./devices/happi ];
    };
  };
}
