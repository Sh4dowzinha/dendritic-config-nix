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
        settings = {
          Browser = {
            Enabled = true;
            UpdateBinaryPath = false;
          };
          GUI = {
            AdvancedSettings = true;
            ApplicationTheme = "dark";
            HidePasswords = true;
            MinimizeOnClose = true;
            ShowTrayIcon = true;
            TrayIconAppearance = "monochrome-light"
          };
          PasswordGenerator = {
            Length = 64;
          };
          SSHAgent = {
            Enabled = false;
          };
        };
      };
    };

    cacheHome = {
      directories = [
        ".cache/keepassxc"
      ];
    };
  };
}
