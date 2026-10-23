{
  den.aspects.applications.media.obs-studio = {
    nixos = {
      programs.obs-studio = {
        enable = true;
        package = null; # don't install OBS system-wide
        enableVirtualCamera = true; # sets up v4l2loopback + polkit
      };
    };

    homeManager =
      { pkgs, ... }:
      {
        home.sessionVariables.OBS_VKCAPTURE_QUIET = "1";
        programs.obs-studio = {
          enable = true;
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
