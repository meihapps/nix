{ inputs, lib, pkgs, ... }:
let
  # written live by the dmopp/settings-to-nix plugin from the GUI settings
  guiSettings = (import ./noctalia_settings.nix { inherit pkgs; }).settings;
  guiSettingsToml = (pkgs.formats.toml { }).generate "noctalia-settings.toml" guiSettings;

  # replace settings.toml with the repo copy, keeping the wallpaper paths the
  # export plugin deliberately leaves out
  applySettings = pkgs.writers.writePython3 "noctalia-apply-settings" {
    libraries = [ pkgs.python3Packages.tomli-w ];
  } ''
    import os
    import sys
    import tempfile
    import tomllib

    import tomli_w

    src, state_dir = sys.argv[1], sys.argv[2]
    target = os.path.join(state_dir, "settings.toml")

    with open(src, "rb") as f:
        new = tomllib.load(f)
    try:
        with open(target, "rb") as f:
            old = tomllib.load(f)
    except (FileNotFoundError, tomllib.TOMLDecodeError):
        old = {}
    if "wallpaper" in old:
        new["wallpaper"] = old["wallpaper"]

    os.makedirs(state_dir, exist_ok=True)
    fd, tmp = tempfile.mkstemp(dir=state_dir, prefix=".settings.toml.")
    with os.fdopen(fd, "wb") as f:
        tomli_w.dump(new, f)
    os.chmod(tmp, 0o644)
    os.replace(tmp, target)
    open(os.path.join(state_dir, ".setup-complete"), "a").close()
  '';
in
{
  programs.noctalia = {
    enable = true;

    # base config layer (~/.config/noctalia/config.toml); GUI settings live in
    # the state layer, so only things the GUI never writes belong here
    settings.plugins.source = [
      {
        name = "official";
        kind = "path";
        location = "${inputs.noctalia-plugins-official}";
        enabled = true;
      }
      {
        name = "community";
        kind = "path";
        location = "${inputs.noctalia-plugins-community}";
        enabled = true;
      }
    ];

    # commands the enabled plugins shell out to
    extraPackages = with pkgs; [
      bitwarden-cli # bitwarden
      curl
      ffmpeg # screen-toolkit
      glib # tailnet (gio)
      hyprpicker
      imagemagick
      jq
      pulseaudio # pactl
      qrencode
      slurp
      tesseract
      translate-shell
      udiskie # udiskie
      wf-recorder
      wl-screenrec
      xdg-user-dirs # tailnet
      zbar
    ];
  };

  home.activation.noctaliaSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${applySettings} ${guiSettingsToml} "''${XDG_STATE_HOME:-$HOME/.local/state}/noctalia"
  '';
}
