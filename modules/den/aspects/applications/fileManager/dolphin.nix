{
  den.aspects.applications.fileManager.dolphin = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs.kdePackages; [
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
