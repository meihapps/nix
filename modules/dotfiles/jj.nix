{ ... }:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "mei happs";
        email = "mail@meihapps.gay";
      };
      ui = {
        default-command = "log";
      };
    };
  };
}
