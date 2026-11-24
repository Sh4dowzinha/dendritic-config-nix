{
  den.aspects.hardware.bluetooth = {
    nixos = _: {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
        settings.General.Experimental = true;
      };
    };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.bluetui
        ];
      };

    persist = {
      directories = [
        "/var/lib/bluetooth"
      ];
    };
  };
}
