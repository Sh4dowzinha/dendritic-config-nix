{ den, ... }:
{
  den.hosts.x86_64-linux.basalto = {
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

  den.aspects.basalto = {
    includes = with den.aspects; [
      roles.default
      roles.workstation
      roles.gaming
      roles.dev
      roles.dev-gui
      roles.messaging
      roles.media

      hardware.cpu.intel
      hardware.gpu.intel-legacy
      hardware.laptop

      desktop.kde

      disk.btrfs-root-tmpfs-single

      core.network.manager
    ];

    nixos = {
      # WARNING!! DON'T TOUCH THE SYSTEM STATE VERSION IN ANY
      # CIRCUMSTANCE, ONLY IF EXPLICITLY SAID IN THE DOCUMENTATION!
      system.stateVersion = "26.11";
    };

    fona = {
      includes = with den.aspects; [
        applications.browsers.brave-origin
        applications.gaming.prismlauncher
      ];
    };
  };
}
