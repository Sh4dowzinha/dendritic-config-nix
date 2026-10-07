# Deterministic UIDs/GIDs — consistent IDs across all hosts for NFS and service accounts.
#
# Ported from main:modules/_legacy/core/deterministic-uids/
# The option module defines `users.deterministicIds` which auto-assigns uid/gid
# to users/groups via mkForce. The data module provides the central ID registry.
{
  den.aspects.core.users.deterministic-uids = {
    nixos =
      { config, lib, ... }:
      let
        inherit (lib)
          mkForce
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
                      mkIf (v != null) (mkForce v);
                    subUidRanges =
                      let
                        v = cfg.${name}.subUidRanges or [ ];
                      in
                      mkIf (v != [ ]) (mkForce v);
                    subGidRanges =
                      let
                        v = cfg.${name}.subGidRanges or [ ];
                      in
                      mkIf (v != [ ]) (mkForce v);
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
                    mkIf (v != null) (mkForce v);
                }
              )
            );
          };
        };

        config.users.deterministicIds = {
          systemd-oom = uidGid 999;
          systemd-coredump = uidGid 998;
          fwupd-refresh = uidGid 997;
          geoclue = uidGid 996;
          mandb = uidGid 995;
          nm-iodine = uidGid 994;
          nscd = uidGid 993;
          plasmalogin = uidGid 992;
          rtkit = uidGid 991;
          tss = uidGid 990;
          wpa_supplicant = uidGid 989;
          i2c = uidGid 988;
          lpadmin = uidGid 987;
          msr = uidGid 986;
          polkituser = uidGid 985;
          uinput = uidGid 984;
          wireshark = uidGid 983;
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
