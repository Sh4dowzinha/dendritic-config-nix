{
  den.aspects.intel = {
    nixos = {
      hardware.cpu.intel.updateMicrocode = true;
    };
    
    provides.laptop-kbl.nixos = { pkgs, ... }: {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-media-sdk
          intel-ocl
        ];
      };
    };
    
    provides.laptop-adl.nixos = { pkgs, ... }: {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver
          vpl-gpu-rt
          intel-compute-runtime
        ];
      };
      
      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
      };
    };
  };
}
