# Deterministic UIDs/GIDs — consistent IDs across all hosts for NFS and service accounts.
#
# Ported from main:modules/_legacy/core/deterministic-uids/
# The option module defines `users.deterministicIds` which auto-assigns uid/gid
# to users/groups via mkDefault. The data module provides the central ID registry.
{
  den.aspects.core.users.deterministic-uids = {
    nixos =
      { config, lib, ... }:
      let
        inherit (lib)
          mkDefault
          mkIf
          mkOption
          types
          concatLists
          flip
          mapAttrsToList
          ;

        cfg = config.users.deterministicIds;

        uidGid = id: {
          uid = id;
          gid = id;
        };
      in
      {
        options.users = {
          deterministicIds = mkOption {
            default = { };
            description = "Maps user/group name to expected uid/gid values.";
            type = types.attrsOf (
              types.submodule {
                options = {
                  uid = mkOption {
                    type = types.nullOr types.int;
                    default = null;
                  };
                  gid = mkOption {
                    type = types.nullOr types.int;
                    default = null;
                  };
                  subUidRanges = mkOption {
                    type = types.listOf (
                      types.submodule {
                        options = {
                          startUid = mkOption { type = types.int; };
                          count = mkOption { type = types.int; };
                        };
                      }
                    );
                    default = [ ];
                  };
                  subGidRanges = mkOption {
                    type = types.listOf (
                      types.submodule {
                        options = {
                          startGid = mkOption { type = types.int; };
                          count = mkOption { type = types.int; };
                        };
                      }
                    );
                    default = [ ];
                  };
                };
              }
            );
          };

          users = mkOption {
            type = types.attrsOf (
              types.submodule (
                { name, ... }:
                {
                  config = {
                    uid =
                      let
                        v = cfg.${name}.uid or null;
                      in
                      mkIf (v != null) (mkDefault v);
                    subUidRanges =
                      let
                        v = cfg.${name}.subUidRanges or [ ];
                      in
                      mkIf (v != [ ]) (mkDefault v);
                    subGidRanges =
                      let
                        v = cfg.${name}.subGidRanges or [ ];
                      in
                      mkIf (v != [ ]) (mkDefault v);
                  };
                }
              )
            );
          };

          groups = mkOption {
            type = types.attrsOf (
              types.submodule (
                { name, ... }:
                {
                  config.gid =
                    let
                      v = cfg.${name}.gid or null;
                    in
                    mkIf (v != null) (mkDefault v);
                }
              )
            );
          };
        };

        config.users.deterministicIds = {
          systemd-oom = uidGid 999;
          systemd-coredump = uidGid 998;
          sshd = uidGid 997;
          nscd = uidGid 996;
          polkituser = uidGid 995;
          microvm = uidGid 994;
          podman = uidGid 993;
          avahi = uidGid 992;
          colord = uidGid 991;
          geoclue = uidGid 990;
          gnome-remote-desktop = uidGid 989;
          rtkit = uidGid 988;
          openrazer = uidGid 987;
          resolvconf = uidGid 986;
          fwupd-refresh = uidGid 985;
          adbusers = uidGid 984;
          msr = uidGid 983;
          gamemode = uidGid 982;
          greeter = uidGid 981;
          uinput = uidGid 980;
          acme = uidGid 979;
          nginx = uidGid 978;
          wireshark = uidGid 977;
          i2c = uidGid 976;
          tss = uidGid 975;
          docker = uidGid 974;
          gnome-initial-setup = uidGid 973;
          wpa_supplicant = uidGid 972;
          pcscd = uidGid 971;
          git = uidGid 970;
          nm-iodine = uidGid 969;
        };

        config.assertions =
          concatLists (
            flip mapAttrsToList config.users.users (
              name: user: [
                {
                  assertion = user.uid != null;
                  message = "den: non-deterministic uid for '${name}', assign via users.deterministicIds";
                }
                {
                  assertion = !user.autoSubUidGidRange;
                  message = "den: non-deterministic subUids/subGids for: ${name}";
                }
              ]
            )
          )
          ++ flip mapAttrsToList config.users.groups (
            name: group: {
              assertion = group.gid != null;
              message = "den: non-deterministic gid for '${name}', assign via users.deterministicIds";
            }
          );
      };
  };
}
