{
  den.aspects.desktop.xdg = {
    nixos = { pkgs, ... }: {
      xdg = {
        portal = {
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

        terminal-exec = {
          enable = true;
          settings = {
            default = [
              "kitty.desktop"
            ];
          };
        };
      };
    };

    homeManager = {
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
