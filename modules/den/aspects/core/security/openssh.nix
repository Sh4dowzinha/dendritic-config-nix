{ lib, ... }:
{
  den.aspects.core.security.openssh = {
    nixos =
      {
        ...
      }:
      {
        services.openssh = {
          enable = false;
          generateHostKeys = true;
        };
      };

    persist = {
      files = [
        { file = "/etc/ssh/ssh_host_ed25519_key"; how = "symlink"; configureParent = true; }
        { file = "/etc/ssh/ssh_host_ed25519_key.pub"; how = "symlink"; configureParent = true; }
        { file = "/etc/ssh/ssh_host_rsa_key"; how = "symlink"; configureParent = true; }
        { file = "/etc/ssh/ssh_host_rsa_key.pub"; how = "symlink"; configureParent = true; }
      ];
    };
  };
}
