{ den, ... }:
{
  den.hosts.x86_64-linux.victus = {
    channel = "nixos-unstable";
    system-owner = "dani";
    keyboard.layout = "pt";
    timezone = "Europe/Lisbon";

    settings = {
      disk.btrfs-luks-tmpfs-single.device_id = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S5GXNL0X119308M";
      core.system.linux-kernel.flavour = "zen";
      core.preservation.enable = true;
    };
  };

  den.aspects.victus = {
    includes = with den.aspects; [
      roles.default
      roles.workstation
      roles.gaming
      roles.dev
      roles.dev-gui
      roles.messaging
      roles.media

      hardware.cpu.amd
      hardware.gpu.amd
      hardware.gpu.nvidia
      hardware.laptop

      desktop.gnome

      disk.btrfs-luks-root-tmpfs-single

      core.network.manager
    ];

    dani = {
      includes = with den.aspects; [
        applications.browsers.brave-origin
        applications.security.keepassxc
      ];
    };
  };
}
