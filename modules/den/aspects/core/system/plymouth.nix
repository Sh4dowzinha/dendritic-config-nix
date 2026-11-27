{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  den.aspects.core.system.plymouth = {
    settings = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Plymouth graphical boot splash and silent boot kernel parameters.";
      };

      theme = mkOption {
        type = types.str;
        default = "bgrt";
        description = "Plymouth splash theme (set to \"details\" to bypass the two-step/bgrt graphics plugin).";
      };
    };

    nixos =
      { host, ... }:
      let
        cfg = host.settings.core.system.plymouth;
      in
      lib.mkIf cfg.enable {
        boot = {
          plymouth = {
            enable = true;
            theme = cfg.theme;
          };
          consoleLogLevel = lib.mkDefault 3;
          kernelParams = [
            "quiet"
            "rd.udev.log_level=3"
            "rd.systemd.show_status=auto"
          ];
        };
      };

    # Regenerable boot-duration timing cache (optional; safe in /cache rather than /persist)
    cache =
      { host, ... }:
      {
        directories = lib.optional host.settings.core.system.plymouth.enable "/var/lib/plymouth";
      };
  };
}
