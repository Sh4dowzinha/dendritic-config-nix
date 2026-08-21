{
  den.aspects.nvidia = {
    nixos = {
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        nvidiaSettings = true;
        videoAcceleration = true;
      };
    };
    
    provides.gtx1050.nixos = { config, pkgs, ... }: {
      boot = {
        blacklistedKernelModules = [ "i915" ];
        initrd.kernelModules = [
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ];
        
        kernelParams = [
          "snd_hda_core.gpu_bind=0"
        ];
      };
      
      hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
        open = false;
        gsp.enable = false;
        modesetting.enable = true;
        
        powerManagement = {
          enable = true;
          finegrained = false; # Doesn't support Pascal
        };
      };
    };
  };
}
