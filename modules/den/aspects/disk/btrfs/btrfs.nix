{
  den.aspects.disk.btrfs = {
    nixos = { pkgs, ... }: {
      boot.supportedFilesystems.btrfs = true;

      services.btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
      };

      programs.btrfs-heatmap.enable = true;

      environment.systemPackages = with pkgs; [
        btrfs-assistant
        btrfs-list
        btrfs-progs
      ];
    };
  };
}
