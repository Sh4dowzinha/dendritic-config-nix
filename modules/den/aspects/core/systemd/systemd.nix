{
  den.aspects.core.systemd = {
    nixos = {
      systemd.tmpfiles.rules = [
        "d /var/lib/systemd/coredump 0755 root root 7d"
      ];

      services.journald.settings.Journal = {
        SystemMaxUse = "100M";
      };
    };

    persist = {
      files = [
        {
          file = "/var/lib/systemd/random-seed";
          how = "symlink";
          inInitrd = true;
          configureParent = true;
        }
        #"/var/lib/systemd/credential.secret"
      ];
      directories = [
        "/var/lib/systemd/timers"
      ];
    };

    cache = {
      files = [
        "/var/lib/lastlog/lastlog2.db"
      ];
      directories = [
        "/var/lib/systemd/coredump"
      ];
    };
  };
}
