{
  den.aspects.applications.messaging.vesktop = {
    homeManager = {
      programs.vesktop = {
        enable = true;
        vencord = {
          useSystem = true;
        };
      };
    };

    autostart =
      { pkgs, ... }:
      [
        (
          pkgs.makeDesktopItem {
            name = "vesktop-autostart";
            desktopName = "Vesktop";
            exec = "${pkgs.vesktop}/bin/vesktop --start-minimized";
            icon = "vesktop";
            categories = [
              "Network"
              "InstantMessaging"
              "Chat"
            ];
          }
          + "/share/applications/vesktop-autostart.desktop"
        )
      ];

    persistHome = {
      directories = [
        {
          directory = ".config/vesktop";
          mode = "0700";
        }
      ];
    };
  };
}
