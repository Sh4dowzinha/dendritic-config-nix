{
  den,
  lib,
  ...
}:

let
  inherit (den.lib.policy) include;
in
{
  den.policies.include-preservation-user-collector =
    { host, user, ... }:
    lib.optional (host.settings.core.preservation.enable or false) (include {
      includes = [
        den.aspects.core.preservation.user-collector
      ];
    });

  den.schema.user.includes = [
    den.policies.include-preservation-user-collector
  ];
}
