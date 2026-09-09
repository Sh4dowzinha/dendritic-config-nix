{
  den.aspects.desktop.xdg-portal = {
    nixos =
      {
        pkgs,
        inputs',
        ...
      }:
      {
        security.pam.services = {
          gdm.enableGnomeKeyring = true;
          gdm-password.enableGnomeKeyring = true;
          login.enableGnomeKeyring = true;
          hyprlock.text = "auth include login";
          swaylock.text = "auth include login";
        };

        xdg.portal = {
          enable = true;
          xdgOpenUsePortal = true;
          config = {
            common = {
              default = [ "gtk" ];
            };
            gnome = {
              default = [
                "gnome"
                "gtk"
              ];
            };
            hyprland = {
              default = [
                "hyprland"
                "gtk"
              ];
              "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
            };
            kde = {
              default = [
                "kde"
                "gtk"
              ];
              "org.freedesktop.portal.FileChooser" = [ "kde" ];
              "org.freedesktop.portal.OpenURI" = [ "kde" ];
            };
          };
          extraPortals = [
            pkgs.xdg-desktop-portal-gtk
            pkgs.xdg-desktop-portal-gnome
            #            inputs'.hyprland.packages.xdg-desktop-portal-hyprland
            pkgs.kdePackages.xdg-desktop-portal-kde
          ];
        };

        # Necessary for xdg-portal home-manager module to work with useUserPackages
        environment.pathsToLink = [
          "/share/xdg-desktop-portal"
          "/share/applications"
        ];
      };
  };
}
