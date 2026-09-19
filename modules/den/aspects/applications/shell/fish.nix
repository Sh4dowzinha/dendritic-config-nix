{
  den.aspects.applications.shell.fish = {
    homeManager = {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting # Disable greeting
        '';
        generateCompletions = true;
        preferAbbrs = true;
        shellAbbrs = {
          ns = "nix shell nixpkgs#%";
        };
      };
    };

    persistHome = {
      directories = [
        ".local/share/fish"
      ];
    };
  };
}
