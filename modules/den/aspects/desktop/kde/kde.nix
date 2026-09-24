{ den, lib, ... }: {
  den.aspects.desktop.kde = {
    nixos = {
      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        KWIN_DRM_DEVICES = lib.mkIf (den.hasAspect den.aspects.hardware.gpu.optimus.nvidia-primary) "/dev/dri/dgpu1:/dev/dri/igpu1";
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
        ".local/share/baloo/"
      ];
    };
  };
}
