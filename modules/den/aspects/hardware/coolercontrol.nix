{
  den.aspects.hardware.coolercontrol = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ 
          pkgs.liquidctl
          pkgs.lm_sensors
        ];

        programs.coolercontrol.enable = true;
      };
  };
}
