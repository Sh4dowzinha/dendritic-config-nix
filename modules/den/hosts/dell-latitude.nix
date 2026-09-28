{ den, ... }:
{
  den.hosts.x86_64-linux.dell-latitude = {
    channel = "nixos-unstable";
    system-owner = "fona";
    keyboard.layout = "us";
    timezone = "Europe/Lisbon";

    settings = {
      disk.btrfs-root-tmpfs-single.device_id = "/dev/disk/by-id/ata-SK_hynix_SC401_SATA_512GB_MS98N664110108V3W";
      core.system.linux-kernel.flavour = "zen";
      core.preservation.enable = true;
      core.preservation-user.enable = false;
    };
  };

  den.aspects.dell-latitude = {
    includes = with den.aspects; [
      roles.default
      roles.workstation

      hardware.cpu.intel
      hardware.gpu.intel-legacy
      hardware.laptop

      desktop.kde

      disk.btrfs-root-tmpfs-single

      core.network.manager
    ];

    fona = {
      includes = with den.aspects; [
        applications.browsers.brave-origin
        applications.security.keepassxc
      ];
    };
  };
}
