{
  den.aspects.disk.btrfs = {
    nixos = {
      boot.supportedFilesystems.btrfs = true;

#      services.btrfs.autoScrub = {
#        enable = true;
#        fileSystems = [ "/" ];
#      };
    };
  };
}
