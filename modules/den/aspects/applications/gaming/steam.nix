{ den, ... }:
{
  den.aspects.applications.gaming.steam = {
    nixos =
      { pkgs, ... }:
      {
        programs.steam = {
          enable = true;
          extest.enable = true;
          protontricks.enable = true;
          localNetworkGameTransfers.openFirewall = true;

          package = pkgs.steam.override {
            extraEnv = {
              PROTON_ENABLE_WAYLAND = true;
              PROTON_USE_NTSYNC = true;
              PROTON_USE_WOW64 = true;
            };

            extraPkgs =
              pkgs': with pkgs'; [
                gamemode
                libkrb5
                keyutils
              ];
          };

          extraCompatPackages = [
            pkgs.proton-ge-bin
          ];
        };
      };

    homeManager =
      {
        host,
        user,
        lib,
        ...
      }:
      let
        hasNvidia = host.hasAspect den.aspects.hardware.gpu.nvidia;
      in
      {
        home.sessionVariables = {
          MESA_SHADER_CACHE_MAX_SIZE = "12G";
        }
        // lib.optionalAttrs hasNvidia {
          __GL_SHADER_DISK_CACHE_SIZE = "12000000000";
        };
      }
      // lib.optionalAttrs (user.hasAspect den.aspects.desktop.hyprland) {
        wayland.windowManager.hyprland.settings.window_rule = [
          {
            match.class = "^(steam_app_\\d+|gamescope)$";
            tag = "+games";
          }
          {
            match = {
              class = "^(steam)$";
              title = "^(Friends List|Steam Settings)$";
            };
            tag = "+floating";
          }
        ];
      };

    persistHome.directories = [
      ".local/share/Steam"
    ];
  };
}
