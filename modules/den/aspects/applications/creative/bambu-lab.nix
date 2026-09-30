{
  den.aspects.applications.creative.bambu-studio = {
    homeManager = { pkgs, ... }: {
      homePackages = with pkgs; [
        bambu-studio
      ];
    };
  };
}
