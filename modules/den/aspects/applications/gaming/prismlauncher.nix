{ den, ... }: {
  den.aspects.applications.gaming.prismlauncher = {
    homeManager =
      { host, lib, ... }:
      {
        programs.prismlauncher = {
          enable = true;
        }
        // lib.optionalAttrs (host.hasAspect den.aspects.desktop.hyprland) {
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
