# users — enriches NixOS user accounts from den's user entity data.
#
# Parametric aspect (like define-user): takes { host, user } and emits
# NixOS config for uid/gid, SSH keys, system groups, deterministicIds.
#
# Included via den.schema.user.includes so it fires for every resolved user.
#
# Ported from main:modules/core/users/default.nix
{
  lib,
  ...
}:
let
  userEnrich =
    { host, user }:
    let
      inherit (user) userName;
      uid = user.system.uid or null;
      gid = if user.system.gid or null != null then user.system.gid else uid;
      subUidStart = if uid != null then 100000 + ((uid - 1000) * 65536) else null;
    in
    {
      name = "user-enrich/${userName}@${host.name}";

      nixos = { config, ... }: {
        users.deterministicIds.${userName} = lib.optionalAttrs (uid != null) {
          inherit uid gid;
          subUidRanges = lib.optional (subUidStart != null) {
            startUid = subUidStart;
            count = 65536;
          };
          subGidRanges = lib.optional (subUidStart != null) {
            startGid = subUidStart;
            count = 65536;
          };
        };

        users.groups.${userName} = lib.optionalAttrs (gid != null) { inherit gid; };

        users.users.${userName} = {
          group = userName;
          openssh.authorizedKeys.keys = map (k: k.key) (user.identity.sshKeys or [ ]);
          linger = user.system.linger or false;
          description = lib.mkDefault (user.identity.displayName or "");
          hashedPasswordFile = config.sops.secrets."user-${userName}-password".path;
        };

        sops.secrets = {
          "user-${userName}-password" = {
            key = "passwordHash/${userName}";
            neededForUsers = true;
            mode = "0400";
          };
        };
      };
    };
in
{
  # Wire into user schema includes — fires for every resolved user
  den.schema.user.includes = [ userEnrich ];

  # Host-level mutableUsers and userborn settings
  den.aspects.core.users = {
    nixos = {
      users.mutableUsers = false;
      services.userborn.enable = true;
    };
  };
}
