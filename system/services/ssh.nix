{ ... }:
{
  # SSH runs on the host, not in Docker, so it's reachable before any
  # containers start and isn't affected by Docker or VPN state.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
