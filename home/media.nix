{ ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      ytdl-format = "bestvideo[height<=2160]+bestaudio/best";
    };
  };

  xdg.configFile."mpv/script-opts/uosc.conf".text = ''
    color=foreground=CDD6F4,foreground_text=1E1E2E,background=1E1E2E,background_text=CDD6F4,curtain=11111B,success=A6E3A1,error=F38BA8
  '';
}
