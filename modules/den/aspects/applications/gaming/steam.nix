{ den, ... }:
{
  den.aspects.applications.gaming.steam = {
    nixos =
      {
        lib,
        pkgs,
        host,
        ...
      }:
      let
        hasNvidiaPrime = host.hasAspect den.aspects.hardware.gpu.optimus.nvidia-prime;
      in
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
            }
            // lib.optionalAttrs hasNvidiaPrime {
              "__NV_PRIME_RENDER_OFFLOAD" = "1";
              "__NV_PRIME_RENDER_OFFLOAD_PROVIDER" = "NVIDIA-G0";
              "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
              "__VK_LAYER_NV_optimus" = "NVIDIA_only";
            };

            # Only add packages not already bundled in pkgs.steam's default FHS env
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
      { host, lib, ... }:
      let
        hasNvidia =
          host.hasAspect den.aspects.hardware.gpu.nvidia
          || host.hasAspect den.aspects.hardware.gpu.nvidia-legacy
          || host.hasAspect den.aspects.hardware.gpu.optimus.nvidia-prime
          || host.hasAspect den.aspects.hardware.gpu.optimus.nvidia-primary-legacy;
      in
      {
        home.sessionVariables = {
          MESA_SHADER_CACHE_MAX_SIZE = "12G";
        }
        // lib.optionalAttrs hasNvidia {
          __GL_SHADER_DISK_CACHE_SIZE = "12000000000";
        };
      }
      // lib.optionalAttrs (host.hasAspect den.aspects.desktop.hyprland) {
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
