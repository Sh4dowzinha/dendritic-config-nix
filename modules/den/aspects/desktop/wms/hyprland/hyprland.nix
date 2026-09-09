{ den, inputs, ... }:
{
  den.aspects.desktop.hyprland = {
    include = [
      den.aspects.desktop.uwsm
      den.aspects.desktop.noctalia
    ];
    nixos =
      {
        pkgs,
        lib,
        inputs',
        ...
      }:
      {
        nix.settings = {
          substituters = [ "https://hyprland.cachix.org" ];
          trusted-substituters = [ "https://hyprland.cachix.org" ];
          trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
        };
      };
  };
}
