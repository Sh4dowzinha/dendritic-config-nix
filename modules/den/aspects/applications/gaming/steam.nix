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
        hasNvidiaPrimeOnLaptop =
          host.hasAspect den.aspects.hardware.gpu.optimus.nvidia-prime
          && host.hasAspect den.aspects.hardware.laptop;
      in
      {
        nix.settings = {
          substituters = [ "https://nix-gaming.cachix.org" ];
          trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
        };

        environment.systemPackages = with pkgs; [
          winetricks
          wineWow64Packages.waylandFull
        ];

        hardware = {
          steam-hardware.enable = true;
          graphics.enable32Bit = true;
        };

        programs = {
          steam = {
            enable = true;
            protontricks.enable = true;

            package = pkgs.steam.override {
              extraEnv = {
                MANGOHUD = true;
                OBS_VKCAPTURE = true;
                RADV_TEX_ANISO = 16;
                PROTON_ENABLE_WAYLAND = true;
                PROTON_USE_NTSYNC = true;
                PROTON_USE_WOW64 = true;
                PULSE_SINK = "Game";
              }
              // lib.optionalAttrs hasNvidiaPrimeOnLaptop {
                NV_PRIME_RENDER_OFFLOAD = "1";
                "__NV_PRIME_RENDER_OFFLOAD_PROVIDER" = "NVIDIA-G0";
                "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
                "__VK_LAYER_NV_optimus" = "NVIDIA_only";
              };
              extraPkgs =
                pkgs':
                let
                  inherit (pkgs') lib;
                  mkDeps =
                    pkgsSet: with pkgsSet; [
                      qt6.qtwayland
                      xdg-utils
                      libx11
                      libxext
                      libxrender
                      libxi
                      libxinerama
                      libxcursor
                      libxscrnsaver
                      libsm
                      libice
                      libxcb
                      libxrandr
                      libxkbcommon
                      freetype
                      fontconfig
                      glib
                      libpng
                      libpulseaudio
                      libvorbis
                      libkrb5
                      keyutils
                      libglvnd
                      libdrm
                      vulkan-tools
                      vulkan-loader
                      vulkan-validation-layers
                      vulkan-extension-layer
                      (lib.getLib stdenv.cc.cc)
                    ];
                in
                mkDeps pkgs';

              extraLibraries =
                p: with p; [
                  atk
                ];
            };

            extraCompatPackages = [
              pkgs.proton-ge-bin
            ];

            #gamescopeSession = {
            #  enable = true;
            #
            #  args = [
            #    "-W 1920"
            #    "-H 1080"
            #    "-r 60"
            #  ];
            #};
          };
        };
      };

    persistHome.directories = [
      ".local/share/Steam"
    ];
  };
}
