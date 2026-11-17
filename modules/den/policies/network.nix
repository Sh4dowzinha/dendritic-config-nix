# modules/den/policies/network.nix
{
  den,
  lib,
  ...
}:
let
  inherit (den.lib.policy) include;
in
{
  den.policies.include-iwd-frontend =
    { host, ... }:
    lib.optional
      (
        (host.settings.core.network.backend or "networkmanager") == "networkd"
        && host.hasAspect den.aspects.roles.workstation
      )
      (include {
        includes = [
          den.aspects.desktop.iwd-frontend
        ];
      });

  den.schema.host.includes = [
    den.policies.include-iwd-frontend
  ];
}
