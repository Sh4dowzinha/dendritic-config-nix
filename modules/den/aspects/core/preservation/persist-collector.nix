{
  den.aspects.core.preservation.persist-collector = {
    nixos =
      {
        host,
        persist,
        cache,
        lib,
        ...
      }:
      let
        mergePersist = entries: {
          directories = lib.unique (lib.concatMap (e: e.directories or [ ]) entries);
          files = lib.unique (lib.concatMap (e: e.files or [ ]) entries);
        };
      in
      if !(host.preservation.enable or false) then
        { }
      else
        {
          preservation.enable = true;
          preservation.preserveAt."/persist" = mergePersist persist;
          preservation.preserveAt."/cache" = mergePersist cache;
        };
  };
}
