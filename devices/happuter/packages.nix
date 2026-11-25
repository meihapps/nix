{ pkgs, inputs, ... }:
let
  # upstream flake ships the desktop entry and icon in its source but doesn't install them
  librepods = pkgs.symlinkJoin {
    name = "librepods";
    paths = [ inputs.librepods.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    postBuild = ''
      install -Dm644 ${inputs.librepods}/linux-rust/assets/me.kavishdevar.librepods.desktop \
        $out/share/applications/me.kavishdevar.librepods.desktop
      install -Dm644 ${inputs.librepods}/linux-rust/assets/icon.png \
        $out/share/icons/hicolor/256x256/apps/me.kavishdevar.librepods.png
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.autoclicke-rs.packages.${pkgs.stdenv.hostPlatform.system}.default
    glfw3-minecraft
    librepods
    jdk21
    obsidian
    prismlauncher
    ungoogled-chromium
    wowup-cf
  ];
}
