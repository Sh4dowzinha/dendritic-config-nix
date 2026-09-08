{
  den.aspects.applications.dev.git.github = {
    homeManager =
      { pkgs, ... }:
      {
        programs = {
          # GitHub CLI
          gh = {
            enable = true;
            settings.git_protocol = "ssh";
            extensions = [
              pkgs.gh-dash # dashboard extension for gh
              pkgs.gh-f # fzf extension for gh
              pkgs.gh-s # search extension for gh
              pkgs.gh-stack # stack extension for gh
            ];
          };
        };
      };
  };
}
