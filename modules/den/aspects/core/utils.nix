{
  den.aspects.core.utils = {
    os = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        btop
        coreutils
        curl
        fd
        file
        findutils
        killall
        unzip
        wget
        netcat
        tcpdump
      ];
    };

    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        environment.systemPackages = with pkgs; [
          lm_sensors
          lsof
          pciutils
          usbutils
          psmisc
          traceroute
        ];

        # Log diff when system update is applied
        system.activationScripts.diff = {
          supportsDryActivation = true;
          text = ''
            if [[ -e /run/current-system ]]; then
              ${lib.getExe pkgs.nvd} --color=always --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig" || echo "FAILED TO GENERATE DIFF"
            fi
          '';
        };
      };
  };
}
