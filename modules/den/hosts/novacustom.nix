{ den, ... }:
{
  den.hosts.x86_64-linux.novacustom = {
    channel = "nixos-unstable";
    system-owner = "sh4dow";
    keyboard.layout = "pt";
    timezone = "Europe/Lisbon";

    settings = {
      disk.btrfs-luks-tmpfs-single.device_id = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S5GXNL0X119308M";
      core.system.linux-kernel.flavour = "zen";
      core.preservation.enable = true;
      core.preservation-user.enable = true;
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

      desktop.kde
      desktop.plasma-manager

      disk.btrfs-luks-tmpfs-single

      core.network.manager
    ];

    nixos = {
      # WARNING!! DON'T TOUCH THE SYSTEM STATE VERSION IN ANY
      # CIRCUMSTANCE, ONLY IF EXPLICITLY SAID IN THE DOCUMENTATION!
      system.stateVersion = "26.11";
    };

    homeManager = { lib, host, ... }: {
      programs.plasma.input.touchpads = lib.mkIf (host.hasAspect den.aspects.desktop.plasma-manager) [
        {
          accelerationProfile = "default";
          disableWhileTyping = false;
          enable = true;
          leftHanded = false;
          name = "ELAN0412:00 04F3:3240 Touchpad";
          naturalScroll = true;
          productId = "3240";
          tapToClick = true;
          vendorId = "04f3";
        }
      ];
    };

    sh4dow = {
      includes = with den.aspects; [
        applications.browsers.brave-origin
        applications.gaming.osu-lazer
        applications.engineering.vivado
        applications.engineering.ltspice

        core.preservation-user
      ];
    };
  };
}
