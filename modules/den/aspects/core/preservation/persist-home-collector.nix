{
  den.aspects.core.preservation.persist-home-collector = {
    nixos =
      {
        #user,
        persistHome,
        cacheHome,
        lib,
        ...
      }:
      let
        mergePersist = entries: {
          directories = lib.unique (lib.concatMap (e: e.directories or [ ]) entries);
          files = lib.unique (lib.concatMap (e: e.files or [ ]) entries);
        };
      in
      {
        #preservation.preserveAt."/persist".users.${user.userName} = mergePersist persistHome;
        #preservation.preserveAt."/cache".users.${user.userName} = mergePersist cacheHome;
        preservation.preserveAt."/persist".users.sh4dow = mergePersist persistHome;
        preservation.preserveAt."/cache".users.sh4dow = mergePersist cacheHome;
      };
  };
}
