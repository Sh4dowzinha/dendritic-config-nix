{
  den.aspects.services.network.mullvad-vpn = {
    nixos = _: {
      services.mullvad-vpn = {
        enable = true;
        enableEarlyBootBlocking = true;
        enableExcludeWrapper = true;
      };
    };

    homeManager = { pkgs, ... }: {
      programs.mullvad-vpn = {
        enable = true;
        settings = {
          animateMap = true;
          autoConnect = true;
          browsedForSplitTunnelingApplications = [ ];
          changelogDisplayedForVersion = "";
          enableSystemNotifications = true;
          monochromaticIcon = false;
          preferredLocale = "system";
          startMinimized = false;
          unpinnedWindow = true;
          updateDismissedForVersion = "";
        };
      };

      xdg.autostart.entries = [
        "${pkgs.mullvad-vpn}/share/applications/mullvad-vpn.desktop"
      ];
    };

    persist.directories = [
      {
        directory = "/etc/mullvad-vpn";
        mode = "0700";
      }
    ];

    cache.directories = [
      {
        directory = "/var/cache/mullvad-vpn";
        mode = "0700";
      }
    ];
  };
}
