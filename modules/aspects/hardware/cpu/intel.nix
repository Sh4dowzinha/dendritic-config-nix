{
  den.aspects.intel = {
  
    provides.laptop-kbl.nixos = { pkgs, ... }: {
      hardware.cpu.intel.updateMicrocode = true;
      services.thermald.enable = true;
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
    };
    
    provides.laptop-adl.nixos = { pkgs, ... }: {
      hardware.cpu.intel.updateMicrocode = true;
      services.thermald.enable = true;
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
