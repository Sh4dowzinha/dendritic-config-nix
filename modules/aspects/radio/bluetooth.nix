{
  den.aspects.bluetooth = {
    nixos = {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
      };
    };
    
    preservation-class = {
      directories = [
        "/var/lib/bluetooth"
      ];
    };
  };
}
