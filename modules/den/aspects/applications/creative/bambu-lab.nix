{
  den.aspects.applications.creative.bambu-studio = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        bambu-studio
      ];
    };
  };
}
