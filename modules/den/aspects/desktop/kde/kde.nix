{
  den.aspects.desktop.kde = {
    nixos = {
      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
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
