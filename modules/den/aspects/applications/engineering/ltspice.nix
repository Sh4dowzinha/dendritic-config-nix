{ den, ... }: {
  den.aspects.applications.engineering.ltspice = {
    homeManager =
      {
        user,
        lib,
        pkgs,
        ...
      }:
      {
        home.packages = [
          pkgs.local.ltspice
        ];
      }
      // lib.optionalAttrs (user.hasAspect den.aspects.desktop.hyprland) {
        wayland.windowManager.hyprland.settings.window_rule = [
          {
            match.class = "^(ltspice.*)$";
            tag = "+crisp";
          }
        ];
      };

    persistHome.directories = [
      ".local/share/wineprefixes/ltspice"
    ];
  };
}
