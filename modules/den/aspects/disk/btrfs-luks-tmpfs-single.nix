{
  den,
  inputs,
  lib,
  ...
}:
{
  den.aspects.disk.btrfs-luks-tmpfs-single = {
    includes = [
      den.aspects.disk.btrfs
    ];

    settings = {
      device_id = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Disk device id (e.g., "ata-..." or "/dev/disk/by-id/...").
          If not set, auto-detects a single non-USB disk via facter.
        '';
      };

      swap_size = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "Size of swap in MiB, 0 disables swap.";
      };

      tmpfsSize = lib.mkOption {
        type = lib.types.str;
        default = "25%";
        description = "Size cap for the tmpfs root";
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
        cfg = host.settings.disk.btrfs-luks-tmpfs-single;

        disk-device =
          if cfg.device_id != "" then
            if lib.hasPrefix "/dev/" cfg.device_id then cfg.device_id else "/dev/disk/by-id/" + cfg.device_id
          else
            let
              native-disks = builtins.filter (f: f.driver != "usb-storage") config.facter.report.hardware.disk;
              disk-labels = map (
                disk:
                builtins.head (
                  builtins.filter (f: builtins.substring 0 16 f == "/dev/disk/by-id/") disk.unix_device_names
                )
              ) native-disks;
            in
            if (builtins.length disk-labels == 1) then
              (builtins.head disk-labels)
            else
              abort (
                "Multiple disks found. Please set settings.disk.btrfs-disko.device_id. Found: "
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
      in
      {
        imports = [ inputs.disko.nixosModules.default ];

        config = {
          disko.devices = {
            nodev."/" = {
              fsType = "tmpfs";
              mountOptions = [
                "defaults"
                "size=${cfg.tmpfsSize}"
                "mode=755"
              ];
            };
            disk = {
              main = {
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
                    luks = {
                      size = "100%";
                      label = "luks";
                      content = {
                        type = "luks";
                        name = "cryptroot";
                        passwordFile = "/tmp/secret.key";
                        settings = {
                          allowDiscards = true;
                          bypassWorkqueues = true;
                        };
                        content = {
                          type = "btrfs";
                          extraArgs = [
                            "-L"
                            "nixos"
                            "-f"
                          ];
                          subvolumes = {
                            "/nix" = {
                              mountpoint = "/nix";
                              mountOptions = defaultBtrfsOpts;
                            };
                            "/persist" = {
                              mountpoint = "/persist";
                              mountOptions = defaultBtrfsOpts;
                            };
                            "/cache" = {
                              mountpoint = "/cache";
                              mountOptions = defaultBtrfsOpts;
                            };
                          }
                          // lib.optionalAttrs (cfg.swap_size > 0) {
                            "@swap" = {
                              mountpoint = "/swap";
                              swap.swapfile.size = "${toString cfg.swap_size}M";
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
          fileSystems = {
            "/nix".neededForBoot = true;
            "/persist".neededForBoot = true;
            "/cache".neededForBoot = true;
          };
        };
      };
  };
}
