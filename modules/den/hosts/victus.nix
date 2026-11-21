{ den, ... }:
{
  den.hosts.x86_64-linux.victus = {
    channel = "nixos-unstable";
    system-owner = "dani";
    keyboard.layout = "pt";
    timezone = "Europe/Lisbon";

    settings = {
      disk.btrfs-single = {
        device_id = "/dev/disk/by-id/nvme-PHIXERO_BC07985E01071850320";
        encrypt = true;
      };

      core.system.linux-kernel.flavour = "zen";
      core.preservation.enable = true;
      core.preservation-user.enable = true;

      desktop.iwd-frontend.tool = "both";

      core.network = {
        backend = "networkd";
        mode = "declarative";

        # Ignore router/ISP DNS so systemd-resolved uses Quad9 FallbackDNS from dns.nix
        # when VPN is disconnected, and Mullvad's 10.64.0.1 (~.) when connected.
        ignoreDHCPDNS = true;

        # Provisioned via sops-nix into /var/lib/iwd/*.psk and *.8021x
        wirelessNetworks = {
          home = {
            ssid = "NOS-F856";
            auth = "wpa-psk";
            sopsKey = "wifi/home-psk";
            priority = 100;
          };

          hotspot = {
            ssid = "Redmi-Note-9T";
            auth = "wpa-psk";
            sopsKey = "wifi/hotspot-psk";
            priority = 100;
          };

          hackerschool = {
            ssid = "HackerSchool_Lab_5G";
            auth = "wpa-psk";
            sopsKey = "wifi/hackerschool-psk";
            priority = 100;
          };

          vodafone = {
            ssid = "Vodafone";
            auth = "wpa-psk";
            sopsKey = "wifi/vodafone-psk";
            priority = 100;
          };
        };
      };
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
      roles.cad
      roles.creative.graphics
      roles.creative.video

      hardware.cpu.amd
      hardware.gpu.amd
      hardware.gpu.nvidia
      hardware.gpu.optimus.nvidia-prime
      hardware.laptop
      hardware.nbfc-linux

      desktop.kde
      desktop.plasma-manager

      applications.engineering.boards
    ];

    nixos =
      { config, pkgs, ... }:
      {
        sops.secrets = {
          "wireguard/victus/private-key" = { };
          "wireguard/victus/psk" = { };
          "wireguard/victus/endpoint" = { };
        };

        networking.wg-quick.interfaces.victus = {
          autostart = false;
          address = [
            "10.236.97.3/24"
            "fd11:5ee:bad:c0de::aec:6103/64"
          ];

          dns = [
            "9.9.9.9"
            "149.112.112.112"
          ];

          privateKeyFile = config.sops.secrets."wireguard/victus/private-key".path;

          peers = [
            {
              publicKey = "/qvQLiu2QxRZ/ulOuSykZG2ou6AWTXAVJyFyhgWVi18=";
              presharedKeyFile = config.sops.secrets."wireguard/victus/psk".path;
              allowedIPs = [
                "0.0.0.0/0"
                "::/0"
              ];
            }
          ];

          postUp = ''
            ${pkgs.wireguard-tools}/bin/wg set victus \
              peer '/qvQLiu2QxRZ/ulOuSykZG2ou6AWTXAVJyFyhgWVi18=' \
              endpoint "$(cat ${config.sops.secrets."wireguard/victus/endpoint".path})"
          '';
        };

        environment.etc."nbfc/nbfc.json".text = ''
          {
            "SelectedConfigId": "HP Victus 15-fb0xxx"
          }
        '';

        # WARNING!! DON'T TOUCH THE SYSTEM STATE VERSION IN ANY
        # CIRCUMSTANCE, ONLY IF EXPLICITLY SAID IN THE DOCUMENTATION!
        system.stateVersion = "26.11";
      };

    dani = {
      includes = with den.aspects; [
        applications.browsers.brave-origin
      ];
    };
  };
}
