{ den, lib, ... }:
{
  den.aspects.hardware.gpu.amd = {
    includes = [ den.aspects.hardware.gpu.common ];

    nixos =
      { pkgs, ... }:
      {
        services.xserver.videoDrivers = lib.mkBefore [ "modesetting" ];

        hardware.amdgpu = {
          opencl.enable = true;
          initrd.enable = true;
        };

        environment.systemPackages = with pkgs; [
          amdgpu_top
        ];
      };
  };
}
