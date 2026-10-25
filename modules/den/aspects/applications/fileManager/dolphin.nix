{
  den.aspects.applications.fileManager.dolphin = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs.kdePackages; [
        dolphin
        dolphin-plugins
        kaccounts-integration
        kaccounts-providers
        kio
        kio-admin
        kio-extras
        kio-fuse
        kio-gdrive
        kio-zeroconf
      ];
    };
  };
}
