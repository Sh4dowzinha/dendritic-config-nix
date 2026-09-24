{
  den.aspects.hardware.gpu.amd = {
    nixos =
      { pkgs, ... }:
      {
        hardware = {
          amdgpu = {
            opencl.enable = true;
            initrd.enable = true;
          };

          graphics = {
            enable = true;
            enable32Bit = true;
            extraPackages = [
              pkgs.libva-vdpau-driver
              pkgs.libva
              pkgs.libvdpau-va-gl
              pkgs.vulkan-tools
              pkgs.vulkan-loader
              pkgs.vulkan-validation-layers
              pkgs.vulkan-extension-layer
            ];
          };
        };

        environment.systemPackages = [
          pkgs.pciutils
          pkgs.clinfo
          pkgs.nvtopPackages.amd
          pkgs.amdgpu_top
          pkgs.vulkan-tools
          pkgs.vulkan-loader
          pkgs.vulkan-validation-layers
          pkgs.vulkan-extension-layer
          pkgs.libva-utils
          pkgs.mesa-demos
        ];
      };
  };
}
