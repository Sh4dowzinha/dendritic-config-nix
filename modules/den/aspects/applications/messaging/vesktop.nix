{
  den.aspects.applications.messaging.vesktop = {
    homeManager = { pkgs, ... }: {
      programs.vesktop = {
        enable = true;
        vencord = {
        };
      };

      xdg.autostart.entries = [
        (
          pkgs.makeDesktopItem {
            name = "vesktop-autostart";
            desktopName = "Vesktop";
            exec = "${pkgs.vesktop}/bin/vesktop --start-minimized";
            icon = "vesktop";
          }
          + "/share/applications/vesktop-autostart.desktop"
        )
      ];
    };

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
