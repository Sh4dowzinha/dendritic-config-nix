{
  den,
  lib,
  ...
}:
{
  den.aspects.disk.btrfs-single = {
    includes = [
      den.aspects.core.system.disko
      den.aspects.disk.btrfs
    ];

    settings = {
      device_id = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Disk device id (e.g., "ata-..." or "/dev/disk/by-id/...").
          If empty, auto-detects a single non-USB disk via facter.
        '';
      };

      encrypt = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to encrypt the Btrfs partition with LUKS.";
      };

      passwordFile = lib.mkOption {
        type = lib.types.str;
        default = "/tmp/secret.key";
        description = "Path to the LUKS passphrase file used during initial disko formatting.";
      };

      swap_size = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "Size of swapfile in MiB; 0 disables swap.";
      };

      tmpfsSize = lib.mkOption {
        type = lib.types.str;
        default = "25%";
        description = "Size cap for the tmpfs root when core.preservation.enable is true.";
      };
    };

    nixos =
      {
        config,
        lib,
        host,
        ...
      }:
      let
        cfg = host.settings.disk.btrfs-single;

        useRootPreservation = host.settings.core.preservation.enable or true;
        useUserPreservation = useRootPreservation && (host.settings.core.preservation-user.enable or false);

        disk-device =
          if cfg.device_id != "" then
            if lib.hasPrefix "/dev/" cfg.device_id then cfg.device_id else "/dev/disk/by-id/" + cfg.device_id
          else
            let
              native-disks = builtins.filter (f: (f.driver or "") != "usb-storage") (
                lib.attrByPath [ "hardware" "disk" ] [ ] config.hardware.facter.report
              );
              disk-labels = lib.filter (x: x != null) (
                map (
                  disk: lib.findFirst (lib.hasPrefix "/dev/disk/by-id/") null (disk.unix_device_names or [ ])
                ) native-disks
              );
            in
            if builtins.length disk-labels == 1 then
              builtins.head disk-labels
            else if builtins.length disk-labels == 0 then
              abort "No non-USB disk with /dev/disk/by-id/ found via facter. Set settings.disk.btrfs-single.device_id."
            else
              abort (
                "Multiple disks found. Please set settings.disk.btrfs-single.device_id. Found: "
                + toString disk-labels
              );

        defaultESPOpts = [
          "defaults"
          "nodev"
          "nosuid"
          "noexec"
          "fmask=0177"
          "dmask=0077"
        ];

        defaultBtrfsOpts = [
          "defaults"
          "compress=zstd:1"
          "noatime"
        ];

        btrfsContent = {
          type = "btrfs";
          extraArgs = [
            "-L"
            "nixos"
            "-f"
            "-O"
            "bgt"
          ];
          subvolumes = {
            "/nix" = {
              mountpoint = "/nix";
              mountOptions = defaultBtrfsOpts;
            };
          }
          // lib.optionalAttrs useRootPreservation {
            "/persist" = {
              mountpoint = "/persist";
              mountOptions = defaultBtrfsOpts;
            };
            "/cache" = {
              mountpoint = "/cache";
              mountOptions = defaultBtrfsOpts;
            };
          }
          // lib.optionalAttrs (!useRootPreservation) {
            "/" = {
              mountpoint = "/";
              mountOptions = defaultBtrfsOpts;
            };
          }
          // lib.optionalAttrs (!useUserPreservation) {
            "/home" = {
              mountpoint = "/home";
              mountOptions = defaultBtrfsOpts;
            };
          }
          // lib.optionalAttrs (cfg.swap_size > 0) {
            "/swap" = {
              mountpoint = "/swap";
              mountOptions = [ "noatime" ];
              swap.swapfile.size = "${toString cfg.swap_size}M";
            };
          };
        };
      in
      {
        disko.devices =
          lib.optionalAttrs useRootPreservation {
            nodev."/" = {
              fsType = "tmpfs";
              mountOptions = [
                "defaults"
                "size=${cfg.tmpfsSize}"
                "mode=755"
              ];
            };
          }
          // {
            disk.main = {
              device = disk-device;
              type = "disk";
              content = {
                type = "gpt";
                partitions = {
                  ESP = {
                    label = "boot";
                    name = "ESP";
                    size = "512M";
                    type = "EF00";
                    content = {
                      type = "filesystem";
                      format = "vfat";
                      mountpoint = "/boot";
                      mountOptions = defaultESPOpts;
                    };
                  };
                }
                // (
                  if cfg.encrypt then
                    {
                      luks = {
                        size = "100%";
                        label = "luks";
                        content = {
                          type = "luks";
                          name = "cryptroot";
                          passwordFile = cfg.passwordFile;
                          settings = {
                            allowDiscards = true;
                            bypassWorkqueues = true;
                          };
                          content = btrfsContent;
                        };
                      };
                    }
                  else
                    {
                      nixos = {
                        size = "100%";
                        content = btrfsContent;
                      };
                    }
                );
              };
            };
          };

        fileSystems = {
          "/nix".neededForBoot = true;
        }
        // lib.optionalAttrs useRootPreservation {
          "/persist".neededForBoot = true;
          "/cache".neededForBoot = true;
        };
      };
  };
}
