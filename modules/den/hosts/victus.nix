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

      disk.btrfs-luks-root-tmpfs-single

      core.network.manager
    ];

    nixos = { config, ... }: {
      sops = {
        secrets = {
          victus-wireguard-private-key.key = "victus/wireguard/private-key";
          victus-wireguard-psk.key = "victus/wireguard/psk";
          victus-wireguard-endpoint.key = "victus/wireguard/endpoint";
        };

        templates."victus.conf" = {
          mode = "0400";

          content = ''
            [Interface]
            Address = 10.236.97.3/24,fd11:5ee:bad:c0de::aec:6103/64
            DNS = 9.9.9.9, 149.112.112.112
            PrivateKey = ${config.sops.placeholder.victus-wireguard-private-key}

            [Peer]
            PublicKey = /qvQLiu2QxRZ/ulOuSykZG2ou6AWTXAVJyFyhgWVi18=
            PresharedKey = ${config.sops.placeholder.victus-wireguard-psk}
            Endpoint = ${config.sops.placeholder.victus-wireguard-endpoint}
            AllowedIPs = 0.0.0.0/0, ::0/0
          '';
        };
      };

      networking.wg-quick.interfaces = {
        victus.configFile = config.sops.templates."victus.conf".path;
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
        applications.creative.prusa-slicer
        #applications.creative.bambu-studio
        applications.engineering.arduino-ide
      ];
    };
  };
}
