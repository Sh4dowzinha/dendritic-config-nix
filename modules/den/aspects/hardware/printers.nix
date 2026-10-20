{
  den.aspects.hardware.printers = {
    nixos = { pkgs, ... }: {
      services = {
        avahi = {
          enable = true;
          nssmdns4 = true;
          nssmdns6 = true;
          openFirewall = true;
        };

        ipp-usb.enable = true;

        printing = {
          enable = true;
          startWhenNeeded = true;
          stateless = true;
          tempDir = "/tmp/cups";
          drivers = with pkgs; [
            cups-filters
            cups-browsed
            hplipWithPlugin
          ];
        };
      };
    };
  };
}
