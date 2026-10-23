{
  den.aspects.applications.gaming.osu-lazer = {
    homeManager = { inputs', ... }: {
      home.packages = [ inputs'.nix-gaming.packages.osu-lazer-bin ];
    };

    persistHome.directories = [
      ".local/share/osu"
    ];
  };
}
