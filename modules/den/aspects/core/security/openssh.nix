{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  den.aspects.core.security.openssh = {
    settings = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the OpenSSH server (sshd).";
      };
    };

    nixos =
      { host, ... }:
      let
        cfg = host.settings.core.security.openssh;
      in
      {
        services.openssh = {
          enable = cfg.enable;
          hostKeys = [
            {
              path = "/etc/ssh/ssh_host_ed25519_key";
              type = "ed25519";
            }
          ];
          settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            PermitRootLogin = "no";
          };
        };
      };

    # Kept unconditional even when sshd is disabled so sops-nix can read
    # /persist/etc/ssh/ssh_host_ed25519_key at boot.
    persist = {
      files = [
        {
          file = "/etc/ssh/ssh_host_ed25519_key";
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key.pub";
          how = "symlink";
          configureParent = true;
        }
      ];
    };
  };
}
