{
  den.aspects.hardware.gamepad = {
    nixos =
      { pkgs, ... }:
      {
        hardware = {
          uinput.enable = true;
          xone.enable = true;
          xpadneo.enable = true;
        };

        services.udev.packages = with pkgs; [
          game-devices-udev-rules
        ];
      };
  };
}
