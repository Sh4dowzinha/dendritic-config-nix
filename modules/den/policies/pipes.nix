# Cross-scope quirk routing policies.
{ den, ... }:
let
  inherit (den.lib.policy) pipe;
in
{
  # Expose user-scoped quirk emissions upward along the P edge to the host scope:
  # - resolved-users: user records consumed by host aspects
  # - persistHome / cacheHome: user preservation entries consumed by core.preservation
  # - firewall: per-app firewall ports consumed by core.network.firewall
  # - nix-ld-libraries: FHS library dependencies consumed by nix-ld
  den.policies.expose-user-quirks =
    { user, ... }:
    [
      (pipe.from "resolved-users" [ pipe.expose ])
      (pipe.from "persistHome" [ pipe.expose ])
      (pipe.from "cacheHome" [ pipe.expose ])
      (pipe.from "firewall" [ pipe.expose ])
      (pipe.from "nix-ld-libraries" [ pipe.expose ])
    ];

  den.schema.user.includes = [
    den.policies.expose-user-quirks
  ];
}
