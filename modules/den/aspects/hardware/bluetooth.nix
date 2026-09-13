{
  den.aspects.hardware.bluetooth = {
    nixos = {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
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
