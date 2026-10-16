{
  den.aspects.disk.btrfs = {
    persist = {
      directories = [
        # records fs scrubbing status
        {
          directory = "/var/lib/btrfs";
          mode = "0700";
        }
      ];
    };

    nixos = { pkgs, ... }: {
      boot.supportedFilesystems.btrfs = true;

      services.btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
      };

      environment.systemPackages = with pkgs; [
        btrfs-list
        btrfs-progs
      ];
    };
  };
}
