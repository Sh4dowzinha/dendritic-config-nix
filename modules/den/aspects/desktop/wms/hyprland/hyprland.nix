# modules/den/aspects/desktop/wms/hyprland/hyprland.nix
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

          extraLuaFiles = {
            "00-nix-env" = {
              autoLoad = true;
              content = ''
                _G.nix_env = {
                  host_name = "${host.name}",
                  kb_layout = "${host.keyboard.layout or "us"}",
                }
              '';
            };
            "10-general" = {
              autoLoad = true;
              content = ./lua/general.lua;
            };
            "20-binds" = {
              autoLoad = true;
              content = ./lua/binds.lua;
            };
            "30-rules" = {
              autoLoad = true;
              content = ./lua/rules.lua;
            };
          };
        };
      };
  };
}
