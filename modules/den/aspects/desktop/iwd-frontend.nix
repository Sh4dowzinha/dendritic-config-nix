{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  den.aspects.desktop.iwd-frontend = {
    settings = {
      tool = mkOption {
        type = types.enum [
          "iwgtk"
          "impala"
          "both"
        ];
        default = "iwgtk";
        description = "Frontend client used to manage iwd on hosts with core.network.backend = \"networkd\".";
      };
    };

    nixos =
      {
        host,
        pkgs,
        lib,
        resolved-users ? [ ],
        ...
      }:
      let
        tool = host.settings.desktop.iwd-frontend.tool or "iwgtk";
        useIwgtk = tool == "iwgtk" || tool == "both";
        useImpala = tool == "impala" || tool == "both";
        userNames = map (u: u.userName or u.name) resolved-users;
      in
      lib.mkMerge [
        {
          assertions = [
            {
              assertion = (host.settings.core.network.backend or "networkmanager") == "networkd";
              message = "desktop.iwd-frontend requires core.network.backend = \"networkd\".";
            }
          ];

          # Allow desktop users to manage iwd over D-Bus without sudo
          users.groups.netdev = { };
          users.users = lib.genAttrs userNames (_: {
            extraGroups = [ "netdev" ];
          });

          environment.systemPackages = lib.optional useIwgtk pkgs.iwgtk ++ lib.optional useImpala pkgs.impala;
        }

        # System-wide user unit (/etc/systemd/user/iwgtk.service) for tray indicator mode
        (lib.mkIf useIwgtk {
          systemd.user.services.iwgtk = {
            description = "iwgtk Wi-Fi system tray indicator";
            after = [ "graphical-session.target" ];
            partOf = [ "graphical-session.target" ];
            wantedBy = [ "graphical-session.target" ];
            serviceConfig = {
              ExecStart = "${pkgs.iwgtk}/bin/iwgtk -i";
              Restart = "on-failure";
              RestartSec = 2;
            };
          };
        })
      ];
  };
}
