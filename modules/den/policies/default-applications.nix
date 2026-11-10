{
  den,
  lib,
  rootPath,
  ...
}:
let
  inherit (den.lib.policy) include;
  defaultApps = import (rootPath + "/modules/den/lib/_default-applications.nix") { inherit den lib; };
in
{
  den.policies.auto-include-default-apps =
    {
      host ? null,
      user,
      ...
    }:
    let
      effectiveDefaults = defaultApps.resolveEffectiveDefaults { inherit host user; };
      aspectsToInclude = defaultApps.getAspectsToInclude effectiveDefaults;
    in
    lib.optional (aspectsToInclude != [ ]) (include {
      includes = aspectsToInclude;
    });

  den.schema.user.includes = [
    den.policies.auto-include-default-apps
  ];
}
