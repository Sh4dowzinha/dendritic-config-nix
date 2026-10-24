{
  den.aspects.roles.cad = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.kicad
          pkgs.freecad-wayland
          pkgs.openscad
          pkgs.prusa-slicer
          pkgs.orca-slicer
        ];
      };

    persistHome = {
      directories = [
        ".config/kicad"
        ".config/FreeCAD"
        ".config/OpenSCAD"
        ".config/PrusaSlicer"
        ".config/OrcaSlicer"
        ".local/share/kicad"
        ".local/share/FreeCAD"
        ".local/share/prusa-slicer"
        ".local/share/orca-slicer"
      ];
    };

    cacheHome = {
      directories = [
        ".cache/kicad"
        ".cache/FreeCAD"
        ".cache/prusa-slicer"
        ".cache/orca-slicer"
      ];
    };
  };
}
