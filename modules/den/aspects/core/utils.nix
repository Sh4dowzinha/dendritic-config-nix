{
  den.aspects.core.utils = {
    os =
      { pkgs, ... }:
      {
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
          fastfetch
        ];
      };

    nixos =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        environment.systemPackages = [
          pkgs.lm_sensors
          pkgs.lsof
          pkgs.pciutils
          pkgs.usbutils
          pkgs.psmisc
          pkgs.traceroute
          pkgs.nh
        ]
        ++ lib.optional config.hardware.nvidia.modesetting.enable pkgs.btop-cuda;
      };
  };
}
