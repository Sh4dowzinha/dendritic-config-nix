{
  den.aspects.applications.gaming.osu-lazer = {
    homeLinux = { inputs', ... }: {
      home.packages = [ inputs'.nix-gaming.packages.osu-lazer-bin ];
    };
  };
}
