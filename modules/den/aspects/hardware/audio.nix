{ den, ... }:
{
  den.aspects.hardware.audio = {
    nixos =
      {
        pkgs,
        lib,
        ...
      }:
      {
        security.rtkit.enable = true;
        services.pulseaudio.enable = lib.mkForce false;

        services.pipewire = {
          enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
          wireplumber.enable = true;
          pulse.enable = true;

          wireplumber.extraConfig."10-bluez" = {
            "monitor.bluez.properties" = {
              "bluez5.enable-sbc-xq" = true;
              "bluez5.enable-msbc" = true;
              "bluez5.enable-hw-volume" = true;
              "bluez5.roles" = [
                "hsp_hs"
                "hsp_ag"
                "hfp_hf"
                "hfp_ag"
              ];
            };
          };

          extraConfig.pipewire."99-playback-96khz" = {
            "context.properties" = {
              "default.clock.rate" = 48000;
              "default.clock.allowed-rates" = [
                44100
                48000
                88200
                96000
                176400
                192000
              ];
            };
          };
        };

        environment.systemPackages = with pkgs; [
          alsa-utils
          playerctl
          pwvucontrol
          qpwgraph
        ];
      };

    homeManager =
      {
        host,
        lib,
        pkgs,
        ...
      }:
      {
        home.packages = with pkgs; [
          wiremix
          cava
        ];
      }
      // lib.optionalAttrs (host.hasAspect den.aspects.desktop.hyprland) {
        wayland.windowManager.hyprland.settings.window_rule = lib.mkMerge [
          [
            {
              match.class = "^(com\\.saivert\\.pwvucontrol)$";
              tag = "+floating";
            }
          ]
          (lib.mkAfter [
            {
              match.class = "^(com\\.saivert\\.pwvucontrol)$";
              size = [
                760
                520
              ];
            }
          ])
        ];
      };

    persistHome = {
      directories = [
        ".local/state/wireplumber"
      ];
    };
  };
}
