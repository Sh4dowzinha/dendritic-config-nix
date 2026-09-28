{
  den.aspects.desktop.xdg = {
    nixos = { pkgs, ... }: {
      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config = {
          common = {
            default = [ "gtk" ];
          };
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];
      };
    };

    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        xdg-utils
      ];

      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
        };

        autostart = {
          enable = true;
          # readOnly = true;   # Keep disabled for now
        };
      };
    };
  };
}
