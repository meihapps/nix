{ stdenv, fetchFromGitHub, nim }:

stdenv.mkDerivation rec {
  pname = "catnap";
  version = "unstable-2025-05-30";

  src = fetchFromGitHub {
    owner = "iinsertNameHere";
    repo = "catnap";
    rev = "5b70ae184e7d709e8229d2bba1d18a262d899441";
    sha256 = "16npya1x2jns2jcc5f1pjmqbsdxaavrg0qgf7yraya8xq3gb5bgl";
  };

  nativeBuildInputs = [ nim ];

  buildPhase = ''
    nim c \
      --nimcache:$TMPDIR/nimcache \
      --cincludes:$(pwd)/src/extern/headers \
      --path:$(pwd)/src/extern/libraries \
      --passC:-f \
      --mm:arc \
      --threads:on \
      --panics:on \
      --checks:off \
      --verbosity:0 \
      --hints:off \
      -d:danger \
      --opt:speed \
      -d:strip \
      --outdir:./bin \
      ./src/catnap.nim
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/catnap
    install -m755 bin/catnap $out/bin/catnap
    cp config/distros.toml $out/share/catnap/distros.toml
  '';
}
