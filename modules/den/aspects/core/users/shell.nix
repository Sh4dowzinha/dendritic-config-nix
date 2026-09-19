{
  den.aspects.core.users.shell = {
    os = {
      programs.fish = {
        enable = true;
        generateCompletions = true;
      };
    };

    nixos = { pkgs, ... }: {
      environment.enableAllTerminfo = true;
      users.users.root.shell = pkgs.bashInteractive;
      users.defaultUserShell = pkgs.fish;
    };
  };
}
