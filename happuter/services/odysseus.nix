{ pkgs, ... }:
{
  systemd.services.odysseus = {
    description = "Odysseus self-hosted AI workspace";
    after = [ "docker.service" "network-online.target" "nss-lookup.target" "docker-network-services.service" ];
    wants = [ "network-online.target" "nss-lookup.target" ];
    requires = [ "docker.service" "docker-network-services.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "odysseus-start" ''
        set -eu
        if [ ! -d /var/lib/odysseus/.git ]; then
          ${pkgs.git}/bin/git clone https://github.com/pewdiepie-archdaemon/odysseus.git /var/lib/odysseus
        else
          ${pkgs.git}/bin/git -C /var/lib/odysseus pull --ff-only || true
        fi
        cd /var/lib/odysseus
        if [ ! -f .env ]; then
          cp .env.example .env
        fi
        # Attach the odysseus container to the shared services bridge so Caddy
        # can reach it by container name, while keeping the default compose
        # network for internal communication with chromadb/searxng/ntfy.
        cat > docker-compose.override.yml << 'EOF'
services:
  odysseus:
    networks:
      - default
      - services
    environment:
      - OLLAMA_BASE_URL=http://ollama:11434/v1
    volumes:
      - /mnt/happssd/projects:/workspace

  ollama:
    image: ollama/ollama:rocm
    devices:
      - /dev/kfd
      - /dev/dri
    volumes:
      - ollama_data:/root/.ollama
    networks:
      - services
    environment:
      - OLLAMA_KEEP_ALIVE=0
      - OLLAMA_CONTEXT_LENGTH=32768
    restart: unless-stopped

  vllm:
    image: docker.io/rocm/vllm:rocm7.13.0_gfx120X-all_ubuntu24.04_py3.13_pytorch_2.10.0_vllm_0.19.1
    devices:
      - /dev/kfd
      - /dev/dri
    volumes:
      - /var/lib/vllm/cache:/root/.cache/huggingface
    networks:
      - services
    ipc: host
    shm_size: 8g
    group_add:
      - video
    restart: "no"


networks:
  services:
    external: true

volumes:
  ollama_data:
EOF
        ${pkgs.docker}/bin/docker compose up -d --build
      '';
      ExecStop = pkgs.writeShellScript "odysseus-stop" ''
        cd /var/lib/odysseus
        ${pkgs.docker}/bin/docker compose down
      '';
    };
  };
}
