{ den, ... }:
{
  den.hosts.x86_64-linux.victus = {
    channel = "nixos-unstable";
    system-owner = "dani";
    keyboard.layout = "pt";
    timezone = "Europe/Lisbon";

    settings = {
      disk.btrfs-luks-root-tmpfs-single.device_id = "/dev/disk/by-id/nvme-PHIXERO_BC07985E01071850320";
      core.system.linux-kernel.flavour = "zen";
      core.preservation.enable = true;
      core.preservation-user.enable = false;
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
      hardware.gpu.optimus.nvidia-prime
      hardware.laptop
      hardware.nbfc-linux

      desktop.kde
      desktop.plasma-manager

      disk.btrfs-luks-root-tmpfs-single

      core.network.manager
    ];

    nixos = {
      # WARNING!! DON'T TOUCH THE SYSTEM STATE VERSION IN ANY
      # CIRCUMSTANCE, ONLY IF EXPLICITLY SAID IN THE DOCUMENTATION!
      system.stateVersion = "26.11";
    };

    dani = {
      includes = with den.aspects; [
        applications.browsers.brave-origin
        applications.creative.prusa-slicer
        applications.creative.bambu-studio
        applications.engineering.arduino-ide
      ];
    };
  };
}
