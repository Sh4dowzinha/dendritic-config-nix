{ lib, ... }:
{
  den.aspects.hardware.nitrokey3 = {
    nixos =
      { pkgs, ... }:
      {
        hardware.nitrokey.enable = true;
        services.pcscd.enable = lib.mkDefault true;

        environment.systemPackages = with pkgs; [
          nitrokey-app2
          pynitrokey
        ];
      };
  };
}
