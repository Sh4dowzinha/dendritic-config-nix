{
  den,
  lib,
  ...
}:
{
  # Adopt strict user/host content separation (Den #694)
  den.migrations.user-host-content.acknowledged = true;

  # Reserve 'settings' so aspects can declare typed settings without pipeline dispatch
  den.reservedKeys = [ "settings" ];

  # Include den.aspects.<hostname>.<username> when defined on a host aspect.
  # Written as a literal policy record so `emits = [ "edge" ]` is declared explicitly
  # for value-conditional sentinel evaluation.
  den.policies.user-aspect-auto-include = {
    __isPolicy = true;
    name = "user-aspect-auto-include";
    emits = [ "edge" ];
    fn =
      { host, user, ... }:
      lib.optional (den.aspects ? ${host.name} && den.aspects.${host.name} ? ${user.name}) (
        den.lib.policy.include den.aspects.${host.name}.${user.name}
      );
  };

  # Grant wheel (+ networkmanager) only to the host's declared system-owner.
  den.policies.primary-user-for-owner = {
    __isPolicy = true;
    name = "primary-user-for-owner";
    emits = [ "edge" ];
    fn =
      { host, user, ... }:
      lib.optional (user.name == (host.system-owner or null)) (
        den.lib.policy.include den.batteries.primary-user
      );
  };

  # Default user includes — per-user data emission + entity-named aspect auto-include
  den.schema.user.includes = [
    den.aspects.core.users.resolved-user-emitter
    den.policies.user-aspect-auto-include
    den.policies.primary-user-for-owner
  ];

  # Wire den batteries that every host/user should have
  den.default.includes = [
    den.batteries.define-user
    den.batteries.hostname
    den.batteries.host-aspects
    den.batteries.inputs'
    den.batteries.self'
  ];
}
