# Pipe collection policies for cross-scope discovery.
#
# Pipe collection policies for cross-host discovery.
#
# Declares collection policies for all quirks that need cross-host
# aggregation, wired into host schema so every host collects pipe
# entries from peers.
{ den, ... }:

let
  inherit (den.lib.policy) pipe;
in
{
  den.policies.collect-host-addrs =
    { host, ... }:
    [
      (pipe.from "host-addrs" [
        (pipe.collectAll ({ host, ... }: true))
      ])
    ];

  # Bottom-up dual of the collect policies. `resolved-users` is emitted per user
  # at user scope (core/users/resolved-user-emitter.nix) and must bubble up the
  # P edge to the host so host aspects (wireshark, adb, ddcutil, razer,
  # remote-build-server, initrd-SSH) can enumerate the users resolved onto that
  # host. Exposed (not collected): the emit lives below the consumer, not beside
  # it. The emit is pipeline-parametric (`{ user, ... }:`), resolved to a concrete
  # record at the emitting user node before it crosses upward.
  den.policies.expose-resolved-users =
    { user, ... }:
    [
      (pipe.from "resolved-users" [
        pipe.expose
      ])
    ];

  # User-side persistence values are exposed upward to the host so
  # the preservation user collector can consume them in user context.
  den.policies.expose-preservation-user =
    { user, ... }:
    [
      (pipe.from "persistHome" [
        pipe.expose
      ])

      (pipe.from "cacheHome" [
        pipe.expose
      ])
    ];

  den.schema.host.includes = [
    den.policies.collect-host-addrs
  ];

  den.schema.user.includes = [
    den.policies.expose-resolved-users
    den.policies.expose-preservation-user
  ];
}
