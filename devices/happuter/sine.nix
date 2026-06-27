{ pkgs, inputs, ... }:
let
  custom-zen =
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta-unwrapped.overrideAttrs
    (oldAttrs: rec {
      sineconfig = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/sineorg/bootloader/refs/heads/main/program/config.js";
        sha256 = "117a6gkaz1kinjflfzqc6qsb4r06x93w08q4lfdzh5a1cng95s5v";
      };
      configpref = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/sineorg/bootloader/refs/heads/main/program/defaults/pref/config-prefs.js";
        sha256 = "1k0vn555xjagfz3qw25dxs54bxq2wgnw58mqa0h74ykpz939p08l";
      };
      libname = "zen-bin-*";
      postInstall =
        (oldAttrs.postInstall or "")
        + ''
          for libdir in "$out"/lib/${libname}; do
            chmod -R u+w "$libdir"
            cp "${sineconfig}" "$libdir/config.js"
            mkdir -p "$libdir/defaults/pref"
            cp "${configpref}" "$libdir/defaults/pref/config-pref.js"
          done
        '';
    });

  # Sine v2.3.3 built release — has moz-page-nav-button support for Zen 1.21+
  sineEngine = pkgs.fetchzip {
    url = "https://github.com/CosmoCreeper/Sine/releases/download/v2.3.3/engine.zip";
    hash = "sha256-FmUgS4nA+RkJyb53MlzuxFfRhKVxTRLXC+/7dchpXHw=";
    stripRoot = false;
  };

  # Patch settings.mjs: in Zen 1.21+, #category-zen-marketplace was renamed to
  # #ZenMarketplaceCategory. The synchronous querySelector throws TypeError on null
  # before any panel content is injected. Use optional chaining to prevent the crash.
  patchedSineEngine = pkgs.runCommand "sine-engine-patched" { } ''
    cp -rT "${sineEngine}/JS" "$out"
    chmod -R u+w "$out"
    substituteInPlace "$out/core/settings.mjs" \
      --replace-fail \
        'document.querySelector("#category-zen-marketplace").remove()' \
        'document.querySelector("#category-zen-marketplace")?.remove()'
  '';

  sineBoot = pkgs.fetchFromGitHub {
    owner = "sineorg";
    repo = "bootloader";
    rev = "e83ebd5f4137731726c759540166906ca646a939";
    hash = "sha256-JvXNVd0HJ2OtVQuZ3bsOOvJW5VD5TIuZD8zxP1V2Y4Q=";
  };

  profilePath = ".config/zen/wxfg1h0x.Default Profile";
  chromePath = "${profilePath}/chrome";
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  # Engine files — JS/ from engine.zip into chrome/JS/
  home.file."${chromePath}/JS" = {
    source = patchedSineEngine;
    recursive = true;
  };

  # Locales also needed at chrome/locales/ for chrome://locales/ protocol
  home.file."${chromePath}/locales" = {
    source = patchedSineEngine + "/locales";
    recursive = true;
  };

  # Bootloader chrome manifest
  home.file."${chromePath}/utils" = {
    source = sineBoot + "/profile/utils";
    recursive = true;
  };

  # Disable auto-update so Sine doesn't delete its own files on launch
  home.file."${profilePath}/user.js" = {
    text = ''
      user_pref("sine.engine.auto-update", false);
    '';
  };

  programs.zen-browser = {
    enable = true;
    package = pkgs.wrapFirefox custom-zen { };
  };
}
