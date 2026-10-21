{ den, ... }:
{
  den.aspects.desktop.hyprland = {
    includes = [
      den.aspects.desktop.uwsm
      den.aspects.desktop.noctalia
    ];

    nixos = { pkgs, ... }: {
      security.pam.services = {
        login.enableGnomeKeyring = true;
        greetd.enableGnomeKeyring = true;
      };

      xdg.portal = {
        config = {
          hyprland = {
            default = [
              "hyprland"
              "gtk"
            ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          };
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];
      };

      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };
    };

    homeManager = {
      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        systemd.enable = false;

        #extraLuaFiles = {
        #  "default" = {
        #    content = ./default.lua;
        #    autoLoad = true;
        #  };
        #};
      };
    };
  };
}
