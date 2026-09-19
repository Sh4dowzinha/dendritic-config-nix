{
  den.aspects.applications.shell.fish = {
    homeManager = {
      programs.fish = {
        enable = true;
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
