{
  den.aspects.core.systemd = {
    nixos = {
      systemd.tmpfiles.rules = [
        "d /var/lib/systemd/coredump 0755 root root 7d"
      ];

      services.journald.settings.Journal = {
        SystemMaxUse="100M";
      };
    };

    cache = {
      files = [
        "/var/lib/lastlog/lastlog2.db"
      ];
      directories = [
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/timers"
        "/var/lib/systemd/catalog"
        {
          directory = "/var/lib/systemd/network";
          mode = "0755";
          user = "systemd-network";
          group = "systemd-network";
        }
        "/var/log"
      ];
    };
  };
}
