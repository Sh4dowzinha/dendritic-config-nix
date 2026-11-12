# Emits one resolved-users entry per user at user scope.
# Collected at host scope so host-level aspects can enumerate all users.
{
  den.aspects.core.users.resolved-user-emitter = {
    resolved-users =
      { user, ... }:
      {
        inherit (user) name userName groups;
        uid = user.system.uid or null;
        gid = user.system.gid or null;
        linger = user.system.linger or false;
        displayName = user.identity.displayName or "";
        sshKeys = map (k: k.key) (user.identity.sshKeys or [ ]);
      };
  };
}
