{
  den.aspects.trusted-user = { user, ... }: {
    nixos.nix.settings.trusted-users = [ user.userName ];
    darwin.nix.settings.trusted-users = [ user.userName ];
  };
}
