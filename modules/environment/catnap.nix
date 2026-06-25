{ stdenv, fetchFromGitHub, nim }:

stdenv.mkDerivation rec {
  pname = "catnap";
  version = "unstable-2026-06-23";

  src = fetchFromGitHub {
    owner = "iinsertNameHere";
    repo = "catnap";
    rev = "2fc63fefeff20f02df76b8aa5169990581f9edff";
    sha256 = "14gqnhdqjqn9ddzxhyz0pzmj8anj3wflibxsvnrhsfrvni1gvv8f";
  };

  nativeBuildInputs = [ nim ];

  postPatch = ''
    cat > src/extern/headers/getDisk.h << 'EOF'
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <sys/statvfs.h>
    #define GB 1073741824

    const char* getMountPoints() {
        FILE* mounts = fopen("/proc/mounts", "r");
        if (!mounts) return "";

        char line[65536];
        char mountPoint[4096];
        char device[4096];
        char fsType[4096];
        size_t resultSize = 65536;
        char* result = calloc(resultSize, 1);
        if (!result) { fclose(mounts); return ""; }

        while (fgets(line, sizeof(line), mounts)) {
            if (sscanf(line, "%4095s %4095s %4095s", device, mountPoint, fsType) < 2) continue;
            size_t needed = strlen(result) + strlen(mountPoint) + 2;
            if (needed > resultSize) {
                resultSize = needed * 2;
                char* tmp = realloc(result, resultSize);
                if (!tmp) break;
                result = tmp;
            }
            strcat(result, mountPoint);
            strcat(result, ",");
        }

        fclose(mounts);
        char* resultPtr = strdup(result);
        free(result);
        return resultPtr;
    }

    double getTotalDiskSpace(const char* mountingPoint) {
        struct statvfs buffer;
        if (statvfs(mountingPoint, &buffer) != 0) return -1.f;
        return (double)(buffer.f_blocks * buffer.f_frsize) / GB;
    }

    double getUsedDiskSpace(const char* mountingPoint) {
        struct statvfs buffer;
        if (statvfs(mountingPoint, &buffer) != 0) return -1.f;
        const double total = (double)(buffer.f_blocks * buffer.f_frsize) / GB;
        const double available = (double)(buffer.f_bfree * buffer.f_frsize) / GB;
        return total - available;
    }
    EOF
  '';

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
