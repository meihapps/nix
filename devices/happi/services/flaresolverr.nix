{ pkgs, ... }:
{
  systemd.user.services.flaresolverr = {
    Unit = {
      Description = "FlareSolverr Cloudflare bypass proxy";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.flaresolverr}/bin/flaresolverr";
      Restart = "on-failure";
      Environment = [
        "PORT=8191"
        "LOG_LEVEL=info"
        "CAPTCHA_SOLVER=none"
      ];
    };
    Install.WantedBy = [ "default.target" ];
  };
}
