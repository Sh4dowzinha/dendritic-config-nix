# Emits one resolved preservation entry per user at user scope.
# The entry is exposed upward so the host-side preservation collector
# can configure preservation.users.<userName> without needing user
# context itself.

{
  den.aspects.core.preservation.user-emitter = {
    preservation-users =
      {
        user,
        persistHome,
        cacheHome,
        ...
      }:
      {
        inherit (user) userName;
        inherit persistHome cacheHome;
      };
  };
}
