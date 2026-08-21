{ inputs, ... }: {
  den.aspects.novacustom.nixos = {
    imports = [ 
      inputs.disko.nixosModules.disko
    ];
    
    disko.devices = {    
      nodev = {
        "/" = {
          fsType = "tmpfs";
          mountOptions = [
            "defaults"
            "size=25%"
            "mode=755"
          ];
        };
      };
      disk = {
        main = {
          type = "disk";
          device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S5GXNL0X119308M";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                name = "ESP";
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  extraArgs = [ "-n" "BOOT" ];
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" "dmask=0077" ];
                };
              };
              luks = {
                size = "100%";
                type = "8309";
                content = {
                  type = "luks";
                  name = "crypted";
                  passwordFile = "/tmp/secret.key"; # Interactive
                  settings = {
                    allowDiscards = true;
                    bypassWorkqueues = true;
                  };
                  content = {
                    type = "btrfs";
                    extraArgs = [ "-f" "-O" "bgt" ];
                    subvolumes = {
                      "/nix" = {
                        mountpoint = "/nix";
                        mountOptions = [
                          "compress=zstd:1"
                          "noatime"
                          "subvol=/nix"
                        ];
                      };
                      "/persistent" = {
                        mountpoint = "/persistent";
                        mountOptions = [
                          "compress=zstd:1"
                          "noatime"
                          "subvol=/persistent"
                        ];
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
