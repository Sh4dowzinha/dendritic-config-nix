{ lib, ... }: {
  den.aspects.hardware.gpu.intel = {
    nixos = { host, pkgs, ... }: {
      services.xserver.videoDrivers = [ "modesetting" ];

      hardware.graphics = {
        enable = true;
        extraPackages = [
          pkgs.intel-media-driver
          pkgs.vpl-gpu-rt
          pkgs.intel-compute-runtime
        ];
      };

      boot.kernelParams = lib.mkIf (host.gpu.intel.driver == "xe") [
        "i915.force_probe=!${host.gpu.intel.pci-id}"
        "xe.force_probe=${host.gpu.intel.pci-id}"
      ];

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
      };

      environment.systemPackages = [
        pkgs.pciutils
        pkgs.intel-gpu-tools
        pkgs.nvtopPackages.intel
        pkgs.mesa-demos
        pkgs.vulkan-loader
        pkgs.vulkan-validation-layers
        pkgs.vulkan-tools
        pkgs.libva-utils
      ];
    };
  };
}
