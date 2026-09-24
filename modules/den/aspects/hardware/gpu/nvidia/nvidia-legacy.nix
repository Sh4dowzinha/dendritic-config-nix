{
  den.aspects.hardware.gpu.nvidia-legacy = {
    nixos =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        boot = {
          extraModprobeConfig =
            "options nvidia "
            + lib.concatStringsSep " " [
              "NVreg_UsePageAttributeTable=1"
              "nvidia.NVreg_EnableGpuFirmware=0"
            ];
        };

        services.xserver.videoDrivers = [ "nvidia" ];

        hardware.graphics = {
          enable = true;
          extraPackages = [
            pkgs.libva-vdpau-driver
            pkgs.libvdpau
            pkgs.libvdpau-va-gl
            pkgs.nvidia-vaapi-driver
            pkgs.vdpauinfo
            pkgs.libva
            pkgs.libva-utils
          ];
        };

        hardware.nvidia = {
          modesetting.enable = true;
          powerManagement.enable = true;
          open = false;
          nvidiaSettings = false;
          package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
        };

        environment = {
          systemPackages = [
            pkgs.pciutils
            pkgs.nvtopPackages.full
            pkgs.libva-utils
            pkgs.vulkan-tools
            pkgs.mesa-demos
            pkgs.vulkan-loader
            pkgs.vulkan-validation-layers
          ];
        };
      };
  };
}
