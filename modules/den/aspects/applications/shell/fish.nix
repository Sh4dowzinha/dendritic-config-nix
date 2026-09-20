{
  den.aspects.applications.shell.fish = {
    homeManager = {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting # Disable greeting
        '';
        generateCompletions = true;
        shellAbbrs = {
          c = "clear";
          gs = "git switch";
        };
      };
    };

    persistHome = {
      files = [
        {
          file = ".local/share/fish/fish_history";
          mode = "0600";
        }
      ];
    };
  };
}
