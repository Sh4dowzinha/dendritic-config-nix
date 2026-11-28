{ den, ... }: {
  den.aspects.roles.cad = {
    homeManager =
      {
        user,
        lib,
        pkgs,
        ...
      }:
      {
        home.packages = with pkgs; [
          kicad
          freecad-wayland
          openscad
          prusa-slicer
          orca-slicer
        ];
      }
      // lib.optionalAttrs (user.hasAspect den.aspects.desktop.hyprland) {
        wayland.windowManager.hyprland.settings.window_rule = [
          {
            match.class = "^(FreeCAD|KiCad)$";
            tag = "+crisp";
          }
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
