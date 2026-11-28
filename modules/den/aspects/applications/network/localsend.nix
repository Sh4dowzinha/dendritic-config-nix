{ den, ... }: {
  den.aspects.applications.network.localsend = {
    homeManager =
      {
        user,
        lib,
        pkgs,
        ...
      }:
      {
        home.packages = with pkgs; [
          localsend
        ];
      }
      // lib.optionalAttrs (user.hasAspect den.aspects.desktop.hyprland) {
        wayland.windowManager.hyprland.settings.window_rule = lib.mkMerge [
          [
            {
              match.class = "^(localsend)$";
              tag = "+floating";
            }
          ]
          (lib.mkAfter [
            {
              match.class = "^(localsend)$";
              size = [
                520
                640
              ];
            }
          ])
        ];
      };

    firewall = {
      networking.firewall.allowedTCPPorts = [ 53317 ];
      networking.firewall.allowedUDPPorts = [ 53317 ];
    };

    persistHome.files = [
      ".local/share/org.localsend.localsend_app/shared_preferences.json"
    ];
  };
}
