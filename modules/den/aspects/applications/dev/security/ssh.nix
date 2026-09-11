{
  den.aspects.applications.dev.security.ssh = {
    homeManager = {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = {
          "*" = {
            ForwardAgent = false;
            AddKeysToAgent = "no";
            Compression = true;
            ServerAliveInterval = 0;
            ServerAliveCountMax = 3;
            HashKnownHosts = true;
            UserKnownHostsFile = "~/.ssh/known_hosts";
            ControlMaster = "no";
            ControlPath = "~/.ssh/master-%r@%n:%p";
            ControlPersist = "no";
          };
          github = {
            hostname = "github.com";
            user = "git";
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
