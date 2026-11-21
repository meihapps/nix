{ inputs, pkgs, ... }:
{
  imports = [
    ./audio.nix
    inputs.luciole.nixosModules.default
    inputs.noctalia.nixosModules.default
    inputs.umbriel.nixosModules.default
  ];

  services.gvfs.enable = true;

  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      keyboard.layout = "gb";
      session.default = "Umbriel";
    };
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
    };
  };

  users.users.mei.extraGroups = [ "audio" "bluetooth" "i2c" "input" "networkmanager" "render" "uinput" "video" ];

  environment.systemPackages = [ pkgs.firefox ];

  fonts.packages = with pkgs; [
    fira-code
    nerd-fonts.fira-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    enableRedistributableFirmware = true;
    i2c.enable = true;
    uinput.enable = true;
  };

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    gamescope.enable = true;
    luciole.enable = true;
    noctalia.enable = true;
    umbriel.enable = true;
  };

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };

    sharedModules = [
      inputs.umbriel.homeModules.default
    ];

    users.mei.imports = [
      ./gtk.nix
      ./media.nix
      ./mimeapps.nix
      ./packages.nix
      ./pdf.nix
      ./shell.nix
      ./umbriel.nix
    ];
  };
}
