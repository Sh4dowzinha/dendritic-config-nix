{
  den.aspects.core.preservation.persist-home-collector = {
    nixos =
      {
        host,
        user,
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
      if !((host.preservation.enable or false) && (host.preservation.home or false)) then
        { }
      else
        {
          preservation.preserveAt."/persist".users.${user.userName} = mergePersist persistHome;
          preservation.preserveAt."/cache".users.${user.userName} = mergePersist cacheHome;
        };
  };
}
