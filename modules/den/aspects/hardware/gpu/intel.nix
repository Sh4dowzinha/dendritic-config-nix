{
  den.aspects.hardware.gpu.intel = {
    modern = {
      nixos =
      { pkgs, ... }:
      {
        services.xserver.videoDrivers = [ "modesetting" ];

        hardware.graphics = {
          enable = true;
          extraPackages = [
            pkgs.intel-media-driver
            pkgs.vpl-gpu-rt
            pkgs.intel-compute-runtime
          ];
        };

        boot.kernelParams = [
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
    
    legacy = {
      nixos =
      { pkgs, ... }:
      {
        services.xserver.videoDrivers = [ "modesetting" ];

        hardware.graphics = {
          enable = true;
          extraPackages = [
            pkgs.intel-media-driver
            pkgs.intel-ocl
          ];
        };

        boot.kernelParams = [
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
  };
}
