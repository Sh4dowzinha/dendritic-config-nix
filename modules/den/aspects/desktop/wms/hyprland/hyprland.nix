{ den, lib, ... }:
{
  den.aspects.desktop.hyprland = {
    includes = [
      den.aspects.desktop.wayland
      den.aspects.desktop.uwsm
      den.aspects.desktop.noctalia
      den.aspects.desktop.noctalia-greeter
    ];

    nixos =
      { pkgs, ... }:
      {
        services.displayManager.noctalia-greeter.settings.session.default =
          lib.mkDefault "Hyprland (uwsm-managed)";

        security = {
          pam.services = {
            login.enableGnomeKeyring = true;
            greetd.enableGnomeKeyring = true;
          };
        };

        services.gnome.gnome-keyring.enable = true;

        xdg.portal = {
          enable = true;
          config.hyprland = {
            default = [
              "hyprland"
              "gtk"
            ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
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

    homeManager =
      { host, ... }:
      {
        wayland.windowManager.hyprland = {
          enable = true;
          package = null;
          portalPackage = null;
          systemd.enable = false;

          settings.config.input.kb_layout = host.keyboard.layout or "us";

          extraLuaFiles.binds = {
            autoLoad = true;
            content = ./lua/binds.lua;
          };
        };
      };
  };
}
