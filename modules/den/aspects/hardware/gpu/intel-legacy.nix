{
  den.aspects.hardware.gpu.intel-legacy = {
    nixos = { pkgs, ... }: {
      services.xserver.videoDrivers = [ "modesetting" ];

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-media-sdk
          intel-ocl
        ];
      };

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
      };

      environment.systemPackages = with pkgs; [
        pciutils
        intel-gpu-tools
        nvtopPackages.intel
        mesa-demos
        vulkan-loader
        vulkan-validation-layers
        vulkan-tools
        libva-utils
      ];
    };
  };
}
