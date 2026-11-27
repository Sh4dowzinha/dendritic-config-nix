{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  den.aspects.core.security.sudo = {
    settings = {
      wheelNeedsPassword = mkOption {
        type = types.bool;
        default = true;
        description = "Require a password when members of the wheel group run sudo.";
      };
    };

    nixos =
      { host, ... }:
      let
        cfg = host.settings.core.security.sudo;
      in
      {
        security.sudo = {
          enable = true;
          execWheelOnly = true;
          wheelNeedsPassword = cfg.wheelNeedsPassword;
          # Avoid repeating the first-run lecture after every tmpfs reboot
          extraConfig = ''
            Defaults lecture = never
          '';
        };
      };
  };
}
