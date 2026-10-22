{
  den.aspects.applications.media.kdenlive = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.kdePackages.kdenlive
        ];
      };
  };
}
