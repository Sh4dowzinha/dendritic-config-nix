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
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };
  };
}
