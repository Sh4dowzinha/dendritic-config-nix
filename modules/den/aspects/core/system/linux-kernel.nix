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
        kernelPackagesMap = {
          lts = pkgs.linuxPackages;
          latest = pkgs.linuxPackages_latest;
          zen = pkgs.linuxPackages_zen;
        };
      in
      {
        boot.kernelPackages = kernelPackagesMap.${cfg.flavour};
      };
  };
}
