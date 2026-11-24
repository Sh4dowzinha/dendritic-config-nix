{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  den.aspects.hardware.nbfc-linux = {
    settings = {
      configId = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "HP Victus 15-fb0xxx";
        description = "NBFC SelectedConfigId matching the laptop model profile.";
      };

      extraSettings = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "Additional JSON keys merged into /etc/nbfc/nbfc.json.";
      };
    };

    nixos =
      {
        config,
        host,
        pkgs,
        ...
      }:
      let
        cfg = host.settings.hardware.nbfc-linux;
        nbfcConfig = {
          SelectedConfigId = cfg.configId;
        }
        // cfg.extraSettings;
      in
      {
        assertions = [
          {
            assertion = cfg.configId != null;
            message = "hardware.nbfc-linux: host.settings.hardware.nbfc-linux.configId must be set.";
          }
        ];

        environment = {
          systemPackages = [ pkgs.nbfc-linux ];
          etc."nbfc/nbfc.json".text = builtins.toJSON nbfcConfig;
        };

        systemd.services.nbfc_service = {
          description = "NoteBook FanControl service";
          wantedBy = [ "multi-user.target" ];
          path = [ pkgs.kmod ];
          restartTriggers = [ config.environment.etc."nbfc/nbfc.json".source ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.nbfc-linux}/bin/nbfc_service --config-file /etc/nbfc/nbfc.json";
            Restart = "on-failure";
            RestartSec = 2;
          };
        };
      };
  };
}
