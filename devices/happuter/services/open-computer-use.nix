{ pkgs, ... }:
let
  docker  = "${pkgs.docker}/bin/docker";
  compose = "${pkgs.docker-compose}/bin/docker-compose";
  git     = "${pkgs.git}/bin/git";
  repoDir = "/opt/open-computer-use";
  envFile = "/var/lib/open-computer-use/env";
in
{
  systemd.tmpfiles.rules = [
    "d /var/lib/open-computer-use 0700 root root -"
    "d /tmp/computer-use-data 0777 root root -"
  ];

  # Generate a random MCP_API_KEY on first deploy and write the env file.
  # Edit /var/lib/open-computer-use/env to add ANTHROPIC_AUTH_TOKEN for
  # sub_agent() support, or adjust PUBLIC_BASE_URL if needed.
  system.activationScripts.open-computer-use-env = ''
    if [ ! -f "${envFile}" ]; then
      key=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 32)
      printf 'PUBLIC_BASE_URL=https://computeruse.meihapps.gay\nMCP_API_KEY=%s\nDOCKER_IMAGE=open-computer-use:latest\n' "$key" > "${envFile}"
      chmod 600 "${envFile}"
    fi
  '';

  # Clone or fast-forward the repo on each boot.
  systemd.services.open-computer-use-clone = {
    description = "Fetch Open Computer Use source";
    after    = [ "network-online.target" ];
    wants    = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type            = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "ocu-clone" ''
        mkdir -p /opt
        if [ -d "${repoDir}/.git" ]; then
          before=$(${git} -C "${repoDir}" rev-parse HEAD)
          ${git} -C "${repoDir}" fetch origin
          ${git} -C "${repoDir}" reset --hard origin/main
          after=$(${git} -C "${repoDir}" rev-parse HEAD)
          needs_build=0
          [ "$before" != "$after" ] && needs_build=1
        else
          ${git} clone https://github.com/Wide-Moat/open-computer-use.git "${repoDir}"
          needs_build=1
        fi
        cat > "${repoDir}/docker-compose.override.yml" <<'EOF'
services:
  computer-use-server:
    environment:
      - ADDITIONAL_VOLUMES=/mnt/happssd/projects:/mnt/projects:rw,/etc/nixos:/mnt/nixos:rw
EOF
        python3 << 'PYEOF'
import re

path = '/opt/open-computer-use/computer-use-server/docker_manager.py'
with open(path) as f:
    content = f.read()

if '_parse_additional_volumes' not in content:
    # Insert parsing code after the other CONTAINER_* constants
    anchor = 'CONTAINER_CPU_LIMIT = float(os.getenv("CONTAINER_CPU_LIMIT", "1.0"))'
    addition = '''
ADDITIONAL_VOLUMES = os.getenv("ADDITIONAL_VOLUMES", "")

def _parse_additional_volumes() -> dict:
    mounts = {}
    for spec in (s.strip() for s in ADDITIONAL_VOLUMES.split(",") if s.strip()):
        parts = spec.split(":")
        if len(parts) >= 2:
            mounts[parts[0]] = {"bind": parts[1], "mode": parts[2] if len(parts) > 2 else "rw"}
    return mounts
'''
    content = content.replace(anchor, anchor + addition, 1)

    # Inject into the volumes dict
    old_volumes_tail = '            **skill_manager.get_skill_mounts(\n                skill_manager.get_user_skills_sync(current_user_email.get())\n            ),\n        },'
    new_volumes_tail = '            **skill_manager.get_skill_mounts(\n                skill_manager.get_user_skills_sync(current_user_email.get())\n            ),\n            **_parse_additional_volumes(),\n        },'
    content = content.replace(old_volumes_tail, new_volumes_tail, 1)

    with open(path, 'w') as f:
        f.write(content)
    print("[ocu-patch] Patched docker_manager.py with ADDITIONAL_VOLUMES support")
else:
    print("[ocu-patch] docker_manager.py already patched")
PYEOF
        if [ "$needs_build" = "1" ]; then
          ${compose} -f "${repoDir}/docker-compose.yml" build
        fi
      '';
    };
  };

  # Build workspace + server images and start the compose stack.
  # First run builds the sandbox image (~15 min); subsequent starts are fast.
  systemd.services.open-computer-use = {
    description = "Open Computer Use Server";
    after    = [ "docker.service" "docker-network-services.service" "open-computer-use-clone.service" ];
    requires = [ "docker.service" "docker-network-services.service" "open-computer-use-clone.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type             = "oneshot";
      RemainAfterExit  = true;
      WorkingDirectory = repoDir;
      EnvironmentFile  = envFile;
      ExecStart        = "${compose} -f docker-compose.yml -f docker-compose.override.yml up -d";
      ExecStop         = "${compose} -f docker-compose.yml -f docker-compose.override.yml down";
      TimeoutStartSec  = "1800";
    };
  };

  # Bridge computer-use-server into the shared services network so open-webui
  # can reach it by hostname at http://computer-use-server:8081.
  systemd.services.open-computer-use-network = {
    description = "Attach computer-use-server to services Docker network";
    after    = [ "open-computer-use.service" "docker-network-services.service" ];
    requires = [ "open-computer-use.service" "docker-network-services.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type            = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "ocu-net-connect" ''
        ${docker} network connect services computer-use-server 2>/dev/null || true
      '';
      ExecStop = pkgs.writeShellScript "ocu-net-disconnect" ''
        ${docker} network disconnect services computer-use-server 2>/dev/null || true
      '';
    };
  };

  happuter.caddy.virtualHosts."computeruse.meihapps.gay" = "reverse_proxy computer-use-server:8081";
}
