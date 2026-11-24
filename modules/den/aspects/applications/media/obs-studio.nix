{ den, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  den.aspects.applications.media.obs-studio = {
    settings = {
      cudaSupport = mkOption {
        type = types.bool;
        default = false;
        description = "Build obs-studio with CUDA/NVENC hardware encoding support (requires hardware.gpu.nvidia).";
      };
    };

    nixos =
      { host, ... }:
      let
        cfg = host.settings.applications.media.obs-studio;
        hasNvidia = host.hasAspect den.aspects.hardware.gpu.nvidia;
      in
      {
        assertions = [
          {
            assertion = cfg.cudaSupport -> hasNvidia;
            message = "applications.media.obs-studio: cudaSupport = true requires the hardware.gpu.nvidia aspect.";
          }
        ];

        programs.obs-studio = {
          enable = true;
          package = null; # don't install OBS system-wide
          enableVirtualCamera = true; # sets up v4l2loopback + polkit
        };
      };

    homeManager =
      { host, pkgs, ... }:
      let
        cfg = host.settings.applications.media.obs-studio;
      in
      {
        home.sessionVariables.OBS_VKCAPTURE_QUIET = "1";

        programs.obs-studio = {
          enable = true;
          package = lib.mkIf cfg.cudaSupport (pkgs.obs-studio.override { cudaSupport = true; });
          plugins = with pkgs.obs-studio-plugins; [
            obs-backgroundremoval
            obs-gstreamer
            obs-tuna
            obs-vaapi
            obs-vkcapture
            input-overlay
          ];
        };
      };
  };
}
