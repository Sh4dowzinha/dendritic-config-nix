{ den, ... }:
{
  den.hosts.x86_64-linux.novacustom = {
    channel = "nixos-unstable";
    system-owner = "sh4dow";
    keyboard.layout = "pt";
    timezone = "Europe/Lisbon";

    settings = {
      disk.btrfs-single = {
        device_id = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S5GXNL0X119308M";
        encrypt = true;
      };

      core.system.linux-kernel.flavour = "zen";
      core.system.plymouth.enable = false;

      core.security.sudo.wheelNeedsPassword = false;

      core.preservation.enable = true;
      core.preservation-user.enable = true;

      desktop.iwd-frontend.tool = "impala";

      core.network = {
        backend = "networkd";
        mode = "declarative";

        # Ignore router/ISP DNS so systemd-resolved uses Quad9 FallbackDNS from dns.nix
        # when VPN is disconnected, and Mullvad's 10.64.0.1 (~.) when connected.
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

          openlab = {
            ssid = "HackerSchool_Lab_5G";
            auth = "wpa-psk";
            sopsKey = "wifi/openlab-psk";
            priority = 100;
          };

          eduroamIST = {
            ssid = "eduroam";
            auth = "wpa-eap";
            sopsKey = "wifi/eduroamIST-password";
            priority = 80;
            eap = {
              method = "peap";
              phase2Auth = "mschapv2";
              identitySopsKey = "wifi/eduroamIST-identity";
              anonymousIdentity = "anonymous@tecnico.ulisboa.pt";
              domainSuffixMatch = "IST - eduroam";
              caCert = ./certs/ist-root-ca.pem;
            };
          };
        };
      };
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
      roles.cad
      roles.creative.video

      hardware.cpu.intel
      hardware.gpu.intel
      hardware.laptop
      hardware.nitrokey3
      hardware.razer
      hardware.gamepad

      desktop.kde
      desktop.plasma-manager

      services.network.mullvad-vpn
      services.network.i2pd

      applications.engineering.vivado
      applications.engineering.boards
    ];

    nixos = {
      security.pki.certificateFiles = [
        ./certs/ist-root-ca.pem
      ];

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
        programs.plasma.input.touchpads = [
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
      }
      // lib.optionalAttrs (user.hasAspect den.aspects.desktop.hyprland) {
        wayland.windowManager.hyprland.settings = {
          monitor = [
            {
              output = "eDP-1";
              mode = "preferred";
              position = "auto";
              scale = 1.2;
            }
          ];
          device = [
            {
              name = "elan0412:00-04f3:3240-touchpad";
              accel_profile = "adaptive";
            }
          ];
        };
      };

    sh4dow = {
      includes = with den.aspects; [
        applications.browsers.i2p-browser
        applications.gaming.osu-lazer
        applications.engineering.ltspice
        applications.network.localsend
      ];
    };
  };
}
