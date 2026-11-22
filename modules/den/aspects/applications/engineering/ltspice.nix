{ den, ... }: {
  den.aspects.applications.engineering.ltspice = {
    homeManager =
      {
        host,
        lib,
        pkgs,
        ...
      }:
      {
        home.packages = [
          pkgs.local.ltspice
        ];
      }
      // lib.optionalAttrs (host.hasAspect den.aspects.desktop.hyprland) {
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
