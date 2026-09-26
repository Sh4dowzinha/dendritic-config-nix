{ lib, ... }: {
  den.aspects.applications.dev.git.github = {
    settings = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "GitHub username";
      };
    };

    homeManager = { user, pkgs, ... }: {
      programs = {
        gh = {
          enable = true;
          settings.git_protocol = "ssh";
          extensions = [
            pkgs.gh-dash # dashboard extension for gh
            pkgs.gh-f # fzf extension for gh
            pkgs.gh-s # search extension for gh
            pkgs.gh-stack # stack extension for gh
          ];

          hosts = {
            "github.com".user = user.settings.github.username;
          };
        };
      };
    };
  };
}
