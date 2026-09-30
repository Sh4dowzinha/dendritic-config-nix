{
  den.aspects.applications.creative.prusa-slicer = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        prusa-slicer
      ];
    };
  };
}
