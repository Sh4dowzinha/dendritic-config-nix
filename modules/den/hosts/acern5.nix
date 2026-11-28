{ den, ... }:
{
  den.hosts.x86_64-linux.acern5 = {
    channel = "nixos-unstable";
    system-owner = "sh4dow";
    keyboard.layout = "br";
    timezone = "Europe/Lisbon";

    settings = {
      disk.btrfs-single = {
        device_id = "/dev/disk/by-id/ata-SSD_960GB_TD23110000083";
        encrypt = false;
      };

      hardware.gpu.intel.legacy = true;
      hardware.gpu.nvidia = {
        branch = "legacy_580";
        open = false;
        prime.mode = "primary";
      };

      core.system.linux-kernel.flavour = "zen";

      core.security.sudo.wheelNeedsPassword = false;

      core.preservation.enable = true;
      core.preservation-user.enable = true;

      desktop.iwd-frontend.tool = "impala";

      applications.media.obs-studio.cudaSupport = true;

      core.network = {
        backend = "networkd";
        mode = "declarative";

        ignoreDHCPDNS = true;

        macRandomization = "network"; # "network" | "once" | "disabled"
        macRandomizationRange = "full"; # "full" | "nic"

        # Provisioned via sops-nix into /var/lib/iwd/*.psk and *.8021x
        wirelessNetworks = {
          home = {
            ssid = "MEO-FERNANDES";
            auth = "wpa-psk";
            sopsKey = "wifi/home-psk";
            priority = 100;
          };
        };
      };
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
      roles.creative.video

      hardware.cpu.intel
      hardware.gpu.intel
      hardware.gpu.nvidia
      hardware.laptop
      hardware.nitrokey3
      hardware.razer
      hardware.gamepad

      desktop.kde
      desktop.plasma-manager
    ];

    nixos = {
      # WARNING!! DON'T TOUCH THE SYSTEM STATE VERSION IN ANY
      # CIRCUMSTANCE, ONLY IF EXPLICITLY SAID IN THE DOCUMENTATION!
      system.stateVersion = "26.11";
    };

    homeManager =
      {
        lib,
        user,
        ...
      }:
      lib.optionalAttrs (user.hasAspect den.aspects.desktop.plasma-manager) {
        programs.plasma.input.mice = [
          {
            enable = true;
            name = "Razer Razer DeathAdder Essential";
            productId = "0098";
            vendorId = "1532";
            accelerationProfile = "none";
          }
        ];
      };

    sh4dow = {
      includes = with den.aspects; [
        applications.gaming.osu-lazer
        applications.gaming.prismlauncher
      ];
    };
  };
}
