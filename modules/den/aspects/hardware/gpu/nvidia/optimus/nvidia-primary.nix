{ den, ... }:
{
  den.aspects.hardware.gpu.optimus.nvidia-primary = {
    includes = [ den.aspects.hardware.gpu.nvidia-legacy ];

    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        nvidiaCard = lib.lists.findFirst (
          card: card.vendor.name == "nVidia Corporation"
        ) null config.facter.report.hardware.graphics_card;

        amdCard = lib.lists.findFirst (
          card: card.vendor.name == "ATI Technologies Inc"
        ) null config.facter.report.hardware.graphics_card;

        intelCard = lib.lists.findFirst (
          card: card.vendor.name == "Intel Corporation"
        ) null config.facter.report.hardware.graphics_card;
      in
      {
        services.udev.packages =
          let
            icard = if intelCard != null then intelCard else amdCard;
          in
          lib.optionals (icard != null) [
            (pkgs.writeTextDir "lib/udev/rules.d/99-drm-devices.rules" ''
              SYMLINK=="dri/by-path/pci-${icard.sysfs_bus_id}-card", SYMLINK+="dri/igpu1"
              SYMLINK=="dri/by-path/pci-${nvidiaCard.sysfs_bus_id}-card", SYMLINK+="dri/dgpu1"
            '')
          ];
      };
  };
}
