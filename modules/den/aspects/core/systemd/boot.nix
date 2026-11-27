{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  den.aspects.core.systemd.boot = {
    settings = {
      timeout = mkOption {
        type = types.int;
        default = 0;
        description = "Seconds to display the systemd-boot menu (0 hides menu unless a key is held).";
      };

      configurationLimit = mkOption {
        type = types.int;
        default = 15;
        description = "Maximum number of NixOS generations kept in /boot to prevent filling the ESP.";
      };
    };

    nixos =
      { host, ... }:
      let
        cfg = host.settings.core.systemd.boot;
      in
      {
        boot.loader = {
          timeout = lib.mkDefault cfg.timeout;

          systemd-boot = {
            enable = true;
            configurationLimit = lib.mkDefault cfg.configurationLimit;
            consoleMode = lib.mkDefault "max";
          };

          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
          };
        };
      };
  };
}
