{ lib, ... }:
{
  den.aspects.core.system.linux-kernel = {
    settings = {
      flavour = lib.mkOption {
        type = lib.types.enum [
          "lts"
          "latest"
          "zen"
        ];
        default = "latest";
        description = "Kernel flavour";
      };
    };

    nixos =
      { host, pkgs, ... }:
      let
        cfg = host.settings.core.system.linux-kernel;
        kernelName = "linuxPackages_${cfg.flavour}";
      in
      {
        boot.kernelPackages = (if pkgs ? ${kernelName} then pkgs.${kernelName} else pkgs.linuxPackages);
      };
  };
}
