{
  den.aspects.applications.creative.prusa-slicer = {
    homeManager = { pkgs, ... }: {
      homePackages = with pkgs; [
        bambu-studio
      ];
    };
  };
}
