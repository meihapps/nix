{ ... }:
{
  programs.lazygit.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = [ "**/.claude/settings.local.json" ];
    settings = {
      init.defaultBranch = "main";
      user = {
        name = "mei happs";
        email = "mail@meihapps.gay";
      };
    };
  };
}
