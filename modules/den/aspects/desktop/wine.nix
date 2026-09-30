{
  den.aspects.desktop.wine = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        winetricks
        wineWow64Packages.full
      ];
    };
  };
}
