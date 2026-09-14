{ den, ... }:
{
  den.aspects.applications.security.keepassxc = {
    includes = [
      den.aspects.desktop.xdg
    ];

    homeManager = {
      programs.keepassxc = {
        enable = true;
        autostart = true;
        #settings = {
        #  Browser = {
        #    Enabled = true;
        #    UpdateBinaryPath = false;
        #  };
        #  GUI = {
        #    AdvancedSettings = true;
        #    ApplicationTheme = "dark";
        #    HidePasswords = true;
        #  };
        #  SSHAgent = {
        #    Enabled = false;
        #  };
        #};
      };
    };

    persistHome = {
      directories = [
        {
          directory = ".config/keepassxc";
          mode = "0700";
        }
      ];
    };

    cacheHome = {
      directories = [
        ".cache/keepassxc"
      ];
    };
  };
}
