{
  den.aspects.applications.fileManager.dolphin = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs.kdePackages; [
        filelight
        dolphin
        dolphin-plugins
        kio
        kio-admin
        kio-extras
        kio-fuse
        kio-zeroconf
      ];
    };
  };
}
