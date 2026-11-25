{
  den.aspects.applications.dev.security.ssh = {
    homeManager =
      { lib, ... }:
      {
        # Native OpenSSH agent (supports both software ed25519 and FIDO2 -sk keys).
        # Home Manager's sshAuthSock module exports SSH_AUTH_SOCK to shells and systemd user units.
        services.ssh-agent = {
          enable = true;
          defaultMaximumIdentityLifetime = 43200; # 12h, matches gpg-agent defaultCacheTtl
        };

        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;

          settings = {
            github = lib.hm.dag.entryBefore [ "*" ] {
              HostName = "github.com";
              User = "git";
            };

            "*" = {
              ForwardAgent = false;
              AddKeysToAgent = "yes";
              Compression = false;
              ServerAliveInterval = 60;
              ServerAliveCountMax = 3;
              HashKnownHosts = true;
              UserKnownHostsFile = "~/.ssh/known_hosts";
            };
          };
        };
      };

    persistHome = {
      directories = [
        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
    };
  };
}
