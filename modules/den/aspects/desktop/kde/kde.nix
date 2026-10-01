{ den, lib, ... }: {
  den.aspects.desktop.kde = {
    nixos = { host, pkgs, ... }: {
      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        KWIN_DRM_DEVICES = lib.mkIf (host.hasAspect den.aspects.hardware.gpu.optimus.nvidia-primary-legacy) "/dev/dri/dgpu1:/dev/dri/igpu1";
      };

      security.pam.services = {
        plasmalogin.enableKwallet = true;
      };

      xdg = {
        portal.config.kde = {
          default = [
            "kde"
            "gtk"
          ];

          "org.freedesktop.portal.FileChooser" = [ "kde" ];
          "org.freedesktop.portal.OpenURI" = [ "kde" ];
        };
        #terminal-exec
      };

      services.desktopManager.plasma6.enable = true;
      services.displayManager.plasma-login-manager = {
        enable = true;
      };
    };

    persistHome = {
      directories = [
        {
          directory = ".local/share/kwalletd";
          mode = "0700";
        }
      ];

      files = [
        ".config/kwinoutputconfig.json" # Preserve monitor settings
      ];
    };

    cacheHome = {
      directories = [
        ".local/share/baloo"
      ];
    };
  };
}
