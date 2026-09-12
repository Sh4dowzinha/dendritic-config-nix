{
  den.aspects.core.preservation.user-collector = {
    nixos =
      {
        preservation-users,
        lib,
        ...
      }:
      let
        mergePersist = entries: {
          directories = lib.unique (lib.concatMap (entry: entry.directories or [ ]) entries);

          files = lib.unique (lib.concatMap (entry: entry.files or [ ]) entries);
        };

        persistUsers = builtins.listToAttrs (
          map (entry: {
            name = entry.userName;

            value = {
              directories = (mergePersist entry.persistHome).directories;
              files = (mergePersist entry.persistHome).files;
            };
          }) preservation-users
        );

        cacheUsers = builtins.listToAttrs (
          map (entry: {
            name = entry.userName;

            value = {
              directories = (mergePersist entry.cacheHome).directories;
              files = (mergePersist entry.cacheHome).files;
            };
          }) preservation-users
        );
      in
      {
        preservation.preserveAt."/persist".users = persistUsers;
        preservation.preserveAt."/cache".users = cacheUsers;
      };
  };
}
