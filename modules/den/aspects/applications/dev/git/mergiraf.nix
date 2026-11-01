{
  den.aspects.applications.dev.git.mergiraf = {
    homeManager = _: {
      programs.mergiraf = {
        enable = true;
        enableGitIntegration = true;
      };
    };
  };
}
