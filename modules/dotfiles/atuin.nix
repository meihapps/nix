{ ... }:

{
  programs.atuin = {
    enable = true;
    settings = {
      enter_accept = true;
      cmd_only = true;
      workspaces = true;
    };
  };
}
