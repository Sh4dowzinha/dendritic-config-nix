{ lib, ... }:
{
  den.aspects.hardware.ddcutil = {
    nixos =
      {
        pkgs,
        resolved-users ? [ ],
        ...
      }:
      let
        userNames = map (u: u.userName or u.name) resolved-users;
      in
      {
        hardware.i2c.enable = true;

        environment.systemPackages = [
          pkgs.ddcutil
        ];

        users.users = lib.genAttrs userNames (_: {
          extraGroups = [ "i2c" ];
        });
      };
  };
}
