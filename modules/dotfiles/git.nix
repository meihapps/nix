{ ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "mei";
        email = "mail@meihapps.gay";
        signingkey = "/Users/meihapps/.ssh/id_ed25519.pub";
      };
      gpg.format = "ssh";
      pull.rebase = true;
      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
    };
  };
}
