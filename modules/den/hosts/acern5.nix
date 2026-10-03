{ den, ... }:
{
  den.hosts.x86_64-linux.acern5 = {
    channel = "nixos-unstable";
    system-owner = "sh4dow";
    keyboard.layout = "br";
    timezone = "Europe/Lisbon";

    settings = {
      disk.btrfs-tmpfs-single.device_id = "/dev/disk/by-id/ata-SSD_960GB_TD23110000083";
      core.system.linux-kernel.flavour = "zen";
      core.preservation.enable = true;
      core.preservation-user.enable = true;
    };
  };

  den.aspects.acern5 = {
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
      hardware.gpu.intel-legacy
      hardware.gpu.optimus.nvidia-primary-legacy
      hardware.laptop
      hardware.nitrokey3

      desktop.kde
      desktop.plasma-manager

      disk.btrfs-tmpfs-single

      core.network.manager
    ];

    nixos = {
      # WARNING!! DON'T TOUCH THE SYSTEM STATE VERSION IN ANY
      # CIRCUMSTANCE, ONLY IF EXPLICITLY SAID IN THE DOCUMENTATION!
      system.stateVersion = "26.11";
    };

    sh4dow = {
      includes = with den.aspects; [
        applications.browsers.brave-origin
        applications.gaming.osu-lazer
        applications.gaming.prismlauncher

        core.preservation-user
      ];
    };
  };
}
