{ inputs, pkgs, ... }:
{
  imports = [
    ./audio.nix
    inputs.luciole.nixosModules.default
    inputs.umbriel.nixosModules.default
  ];

  services.gvfs.enable = true;

  services.displayManager.noctalia-greeter = {
    enable = true;
    # lets noctalia push theme/wallpaper to the greeter without a polkit prompt
    passwordlessSyncUsers = [ "mei" ];
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
    umbriel.enable = true;
  };

  security.polkit.enable = true;

  # noctalia performance-plus plugin (powerprofilesctl)
  services.power-profiles-daemon.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };

    sharedModules = [
      inputs.noctalia.homeModules.default
      inputs.umbriel.homeModules.default
    ];

    users.mei.imports = [
      ./gtk.nix
      ./media.nix
      ./mimeapps.nix
      ./noctalia.nix
      ./packages.nix
      ./pdf.nix
      ./shell.nix
      ./umbriel.nix
    ];
  };
}
