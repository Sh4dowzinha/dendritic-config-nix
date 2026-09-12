{
  den.aspects.core.preservation.collector = {
    nixos =
      {
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
      {
        preservation.preserveAt."/persist" = mergePersist persist;
        preservation.preserveAt."/cache" = mergePersist cache;
      };
  };
}
