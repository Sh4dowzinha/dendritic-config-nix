{ den, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  den.aspects.hardware.gpu.intel = {
    includes = [ den.aspects.hardware.gpu.common ];

    settings = {
      legacy = mkOption {
        type = types.bool;
        default = false;
        description = "Use legacy Intel OpenCL runtime (Gen8-Gen11) instead of Gen12+/Xe compute and VPL runtimes.";
      };
    };

    nixos =
      { host, pkgs, ... }:
      let
        isLegacy = host.settings.hardware.gpu.intel.legacy or false;
      in
      {
        services.xserver.videoDrivers = lib.mkBefore [ "modesetting" ];

        hardware.graphics.extraPackages =
          with pkgs;
          [ intel-media-driver ]
          ++ (
            if isLegacy then
              [ intel-compute-runtime-legacy1 ]
            else
              [
                vpl-gpu-rt
                intel-compute-runtime
              ]
          );

        environment.sessionVariables = {
          LIBVA_DRIVER_NAME = lib.mkDefault "iHD";
        };

        environment.systemPackages = with pkgs; [
          intel-gpu-tools
        ];
      };
  };
}
