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

    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        lm_sensors
        lsof
        pciutils
        usbutils
        psmisc
        traceroute
      ];
    };
  };
}
