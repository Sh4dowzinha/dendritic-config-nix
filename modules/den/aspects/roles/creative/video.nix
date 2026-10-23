{
  den.aspects.roles.creative.video = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          kdePackages.kdenlive
        ];
      };
  };
}
