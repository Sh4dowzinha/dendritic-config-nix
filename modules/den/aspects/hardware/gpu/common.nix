{
  den.aspects.hardware.gpu.common = {
    nixos =
      { pkgs, ... }:
      {
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };

        environment.systemPackages = with pkgs; [
          pciutils
          nvtopPackages.full
          mesa-demos
          vulkan-tools
          libva-utils
          clinfo
        ];
      };
  };
}
