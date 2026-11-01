{
  den,
  lib,
  ...
}:

let
  inherit (den.lib.policy) include;
in
{
  den.policies.include-preservation-user =
    { host, ... }:
    lib.optional (host.settings.core.preservation-user.enable or false) (include {
      includes = [
        den.aspects.core.preservation-user
      ];
    });

  den.schema.user.includes = [
    den.policies.include-preservation-user
  ];
}
