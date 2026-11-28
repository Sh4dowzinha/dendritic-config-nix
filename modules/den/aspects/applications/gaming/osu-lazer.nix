{ den, ... }: {
  den.aspects.applications.gaming.osu-lazer = {
    homeManager =
      {
        user,
        lib,
        inputs',
        ...
      }:
      {
        home.packages = [ inputs'.nix-gaming.packages.osu-lazer-bin ];
      }
      // lib.optionalAttrs (user.hasAspect den.aspects.desktop.hyprland) {
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
