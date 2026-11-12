{
  lib,
  ...
}:
{
  den.aspects.core.users = {
    nixos =
      {
        config,
        resolved-users ? [ ],
        ...
      }:
      let
        mkUserConfig =
          u:
          let
            userName = u.userName or u.name;
            uid = u.uid or null;
            gid = if (u.gid or null) != null then u.gid else uid;
            subUidStart = if uid != null then 100000 + ((uid - 1000) * 65536) else null;
          in
          {
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
              openssh.authorizedKeys.keys = u.sshKeys or [ ];
              linger = u.linger or false;
              description = lib.mkDefault (u.displayName or "");
              hashedPasswordFile = config.sops.secrets."user-${userName}-password".path;
            };

            sops.secrets."user-${userName}-password" = {
              key = "passwordHash/${userName}";
              neededForUsers = true;
              mode = "0400";
            };
          };
      in
      lib.mkMerge (
        [
          {
            users.mutableUsers = false;
            services.userborn.enable = true;
          }
        ]
        ++ map mkUserConfig resolved-users
      );
  };
}
