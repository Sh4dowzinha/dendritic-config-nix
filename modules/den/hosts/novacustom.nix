{ den, ... }:
{
  den.hosts.x86_64-linux.novacustom = {
    channel = "nixos-unstable";
    system-owner = "sh4dow";
    keyboard.layout = "pt";
    timezone = "Europe/Lisbon";

    settings = {
      disk.btrfs-luks-tmpfs-single.device_id = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S5GXNL0X119308M";
      core.system.linux-kernel.optimization = "x86_64-v3";
      core.preservation.enable = true;
    };
  };

  den.aspects.novacustom = {
    includes = with den.aspects; [
      roles.default
      roles.workstation
      roles.gaming
      roles.dev
      roles.dev-gui
      roles.messaging
      roles.media
      roles.music-production

      hardware.cpu.intel
      hardware.gpu.intel
      hardware.laptop
      hardware.nitrokey3

      desktop.hyprland
      desktop.gdm
      desktop.gnome

      disk.btrfs-luks-tmpfs-single

      core.network.manager
    ];

    sh4dow = {
      includes = with den.aspects; [
        applications.browsers.firefox
        applications.security.keepassxc
      ];
    };
  };
}
