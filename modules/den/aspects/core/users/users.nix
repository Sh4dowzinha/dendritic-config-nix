# users — enriches NixOS user accounts from den's user entity data.
#
# Parametric aspect (like define-user): takes { host, user } and emits
# NixOS config for uid/gid, SSH keys, system groups, deterministicIds.
#
# Included via den.schema.user.includes so it fires for every resolved user.
#
# Ported from main:modules/core/users/default.nix
{
  lib,
  ...
}:
let
  userEnrich =
    { host, user }:
    let
      inherit (user) userName;
    in
    {
      name = "user-enrich/${userName}@${host.name}";

      nixos = {
        users.users.${userName} = {
          openssh.authorizedKeys.keys = map (k: k.key) (user.identity.sshKeys or [ ]);
          linger = user.system.linger or false;
          description = lib.mkDefault (user.identity.displayName or "");
          initialPassword = "12345";
        };
      };

      # macOS account identity (uid/groups/password) is managed out of band, but
      # the authorized keys are not — without this branch a darwin host installs
      # no keys for the user and sshd (publickey-only) rejects every connection.
      # nix-darwin turns `openssh.authorizedKeys.keys` into a managed
      # /etc/ssh/nix_authorized_keys.d/<user> file + AuthorizedKeysCommand, so
      # mirroring the nixos key set here is all that's needed for SSH parity.
      darwin = {
        users.users.${userName}.openssh.authorizedKeys.keys = map (k: k.key) (user.identity.sshKeys or [ ]);
      };
    };
in
{
  # Wire into user schema includes — fires for every resolved user
  den.schema.user.includes = [ userEnrich ];

  # Host-level mutableUsers setting
  den.aspects.core.users = {
    nixos = {
      users.mutableUsers = false;
    };
  };
}
