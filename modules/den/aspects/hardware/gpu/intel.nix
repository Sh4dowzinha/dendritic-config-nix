{
  den.aspects.hardware.gpu.intel = {
    nixos = { pkgs, ... }: {
      services.xserver.videoDrivers = [ "modesetting" ];

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = [
          pkgs.intel-media-driver
          pkgs.vpl-gpu-rt
          pkgs.intel-compute-runtime
        ];
      };

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
