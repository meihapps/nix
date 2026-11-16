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

    # nim's nre needs pcre v1, which nixpkgs dropped; replace the two regexes
    cat > src/catnaplib/noregex.nim << 'EOF'
    import std/strutils

    proc isBatteryName*(s: string): bool =
        ## Matches ^BAT\d+$
        s.len > 3 and s.startsWith("BAT") and s[3..^1].allCharsInSet(Digits)

    proc stripAnsi*(s: string): string =
        ## Removes \e(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])
        var i = 0
        while i < s.len:
            if s[i] == '\e' and i + 1 < s.len and s[i + 1] == '[':
                var j = i + 2
                while j < s.len and s[j] in {'0'..'?'}: inc j
                while j < s.len and s[j] in {' '..'/'}: inc j
                if j < s.len and s[j] in {'@'..'~'}:
                    i = j + 1
                    continue
            elif s[i] == '\e' and i + 1 < s.len and s[i + 1] in {'@'..'Z', '\\'..'_'}:
                i += 2
                continue
            result.add s[i]
            inc i
    EOF

    substituteInPlace src/catnaplib/platform/probe.nim \
      --replace-fail 'import nre' 'import ../noregex' \
      --replace-fail '.contains(nre.re"^BAT\d+$")' '.isBatteryName'
    substituteInPlace src/catnaplib/terminal/colors.nim \
      --replace-fail 'import nre' 'import ../noregex' \
      --replace-fail 's.replace(nre.re"\e(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])", "")' 'stripAnsi(s)'
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
