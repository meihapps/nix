{ ... }:
{
  xdg.configFile."mimeapps.list".force = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/discord" = "vesktop.desktop";
      "x-scheme-handler/discord-455712169795780630" = "discord-455712169795780630.desktop";
      "image/png" = "com.github.aliencoweatcake.imageviewer.desktop";
      "application/pdf" = "zen-beta.desktop";
      "x-scheme-handler/mailto" = "userapp-Thunderbird-WVM8L3.desktop";
      "message/rfc822" = "userapp-Thunderbird-WVM8L3.desktop";
      "x-scheme-handler/mid" = "userapp-Thunderbird-WVM8L3.desktop";
      "x-scheme-handler/discord-409416265891971072" = "discord-409416265891971072.desktop";
      "x-scheme-handler/discord-742222376518811669" = "discord-742222376518811669.desktop";
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
      "application/x-zerosize" = "helix.desktop";
      "text/html" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
      "application/zip" = "xarchiver.desktop";
      "image/gif" = "swayimg.desktop";
    };
    associations.added = {
      "image/jpeg" = [ "com.mitchellh.ghostty.desktop" ];
      "inode/directory" = [ "mpv.desktop" "swayimg.desktop" "com.mitchellh.ghostty.desktop" ];
      "application/x-fishscript" = [ "vim.desktop" ];
      "image/png" = [ "swayimg.desktop" "com.github.aliencoweatcake.imageviewer.desktop" ];
      "application/json" = [ "helix.desktop" ];
      "text/plain" = [ "helix.desktop" ];
      "application/vnd.microsoft.portable-executable" = [ "wine.desktop" ];
      "application/pdf" = [ "org.pwmt.zathura.desktop" "zen-beta.desktop" ];
      "x-scheme-handler/mailto" = [ "userapp-Thunderbird-WVM8L3.desktop" ];
      "x-scheme-handler/mid" = [ "userapp-Thunderbird-WVM8L3.desktop" ];
      "application/vnd.efi.iso" = [ "org.gnome.FileRoller.desktop" "gnome-disk-image-writer.desktop" ];
      "application/vnd.kde.kxmlguirc" = [ "helix.desktop" ];
      "image/svg+xml" = [ "zen-beta.desktop" "helix.desktop" ];
      "application/x-zerosize" = [ "swayimg.desktop" "helix.desktop" ];
      "application/zip" = [ "xarchiver.desktop" ];
      "image/gif" = [ "zen-beta.desktop" "swayimg.desktop" ];
    };
  };
}
