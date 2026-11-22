{ den, ... }: {
  den.aspects.applications.gaming.osu-lazer = {
    homeManager =
      {
        host,
        lib,
        inputs',
        ...
      }:
      {
        home.packages = [ inputs'.nix-gaming.packages.osu-lazer-bin ];
      }
      // lib.optionalAttrs (host.hasAspect den.aspects.desktop.hyprland) {
        wayland.windowManager.hyprland.settings.window_rule = [
          {
            match.class = "^(osu!)$";
            tag = "+games";
          }
        ];
      };

    persistHome.directories = [
      ".local/share/osu"
    ];
  };
}
