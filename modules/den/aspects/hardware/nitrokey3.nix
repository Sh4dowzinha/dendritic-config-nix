{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  den.aspects.hardware.nitrokey3 = {
    settings = {
      pcscd = mkOption {
        type = types.bool;
        default = true;
        description = "Enable pcscd with polkit authorization and route GnuPG scdaemon through PC/SC instead of its internal CCID driver.";
      };
    };

    nixos =
      {
        host,
        pkgs,
        resolved-users ? [ ],
        ...
      }:
      let
        cfg = host.settings.hardware.nitrokey3;
        allowedUsers = map (u: u.userName or u.name) resolved-users;
      in
      {
        # Installs 41-nitrokey.rules (uaccess for FIDO2, HID, nitrokey-app2, pynitrokey)
        hardware.nitrokey.enable = true;

        services.pcscd.enable = cfg.pcscd;

        # pcsclite-with-polkit denies systemd user units (gpg-agent/scdaemon) by default
        # because they run outside a login session cgroup. Authorize resolved host users
        # and wheel without introducing a new Unix group.
        security.polkit = lib.mkIf cfg.pcscd {
          enable = lib.mkDefault true;
          extraConfig = ''
            polkit.addRule(function(action, subject) {
              var allowedUsers = ${builtins.toJSON allowedUsers};
              if (
                (action.id == "org.debian.pcsc-lite.access_pcsc" ||
                 action.id == "org.debian.pcsc-lite.access_card") &&
                (allowedUsers.indexOf(subject.user) >= 0 || subject.isInGroup("wheel"))
              ) {
                return polkit.Result.YES;
              }
            });
          '';
        };

        environment.systemPackages = with pkgs; [
          nitrokey-app2
          pynitrokey
        ];
      };

    homeManager =
      {
        config,
        host,
        pkgs,
        ...
      }:
      let
        cfg = host.settings.hardware.nitrokey3;
      in
      {
        # Avoid pcsc-shared = true here: shared mode re-selects the OpenPGP applet
        # between operations and drops the cached PIN on every Git commit.
        programs.gpg.scdaemonSettings = lib.mkIf (cfg.pcscd && config.programs.gpg.enable) {
          disable-ccid = true;
          pcsc-driver = "${lib.getLib pkgs.pcsclite}/lib/libpcsclite.so.1";
        };
      };
  };
}
