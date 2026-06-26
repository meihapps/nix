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
          ${git} -C "${repoDir}" fetch origin
          ${git} -C "${repoDir}" reset --hard origin/main
        else
          ${git} clone https://github.com/Wide-Moat/open-computer-use.git "${repoDir}"
        fi
        cat > "${repoDir}/docker-compose.override.yml" <<'EOF'
services:
  computer-use-server:
    volumes:
      - /mnt/happssd/projects:/mnt/happssd/projects:rw
      - /etc/nixos:/etc/nixos:rw
EOF
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
      ExecStart        = "${compose} -f docker-compose.yml up --build -d";
      ExecStop         = "${compose} -f docker-compose.yml down";
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
