{ den, ... }:
{
  flake-file.inputs = {
    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  den.aspects.desktop.hyprland = {
    includes = [
      den.aspects.desktop.uwsm
      den.aspects.desktop.noctalia
    ];

    nixos = { inputs', ... }: {
      nix.settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };

      programs.hyprland = {
        enable = true;
        package = inputs'.hyprland.packages.hyprland;
        portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
        withUWSM = true;
      };
    };

    homeManagerModules = { inputs', ... }: [
      inputs'.hyprland.homeManagerModules.default
    ];

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
