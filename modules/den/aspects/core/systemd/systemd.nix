{ lib, ... }:
{
  den.aspects.core.systemd = {
    nixos = {
      systemd.tmpfiles.rules = [
        "d /var/lib/systemd/coredump 0755 root root 7d"
      ];

      systemd.coredump.settings.Coredump = {
        MaxUse = lib.mkDefault "500M";
        KeepFree = lib.mkDefault "1G";
      };

      services.journald.settings.Journal = {
        SystemMaxUse = lib.mkDefault "100M";
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
      ];
      directories = [
        "/var/lib/systemd/timers"
        "/var/lib/systemd/backlight"
      ];
    };

    cache = {
      files = [
        "/var/lib/lastlog/lastlog2.db"
      ];
      directories = [
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/pstore"
      ];
    };
  };
}
