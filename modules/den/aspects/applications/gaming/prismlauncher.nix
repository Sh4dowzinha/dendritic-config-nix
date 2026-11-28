{ den, ... }: {
  den.aspects.applications.gaming.prismlauncher = {
    homeManager =
      {
        user,
        lib,
        ...
      }:
      {
        programs.prismlauncher = {
          enable = true;
        }
        // lib.optionalAttrs (user.hasAspect den.aspects.desktop.hyprland) {
          wayland.windowManager.hyprland.settings.window_rule = [
            {
              match.class = "^(Minecraft.*)$";
              tag = "+games";
            }
          ];
        };
      };
  };
}
