{
  den.aspects.disk.btrfs = {
    persist = {
      directories = [
        # Records filesystem scrubbing status
        {
          directory = "/var/lib/btrfs";
          mode = "0700";
        }
      ];
    };

    nixos =
      { pkgs, lib, ... }:
      {
        boot.supportedFilesystems.btrfs = true;
        programs.compsize.enable = true;

        services.btrfs.autoScrub = {
          enable = true;
          interval = "monthly";
          # /nix is mounted in every mode (with or without preservation),
          # scrubbing the shared Btrfs pool once per cycle.
          fileSystems = lib.mkDefault [ "/nix" ];
        };

        environment.systemPackages = with pkgs; [
          btrfs-list
        ];
      };
  };
}
