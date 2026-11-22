{ den, ... }: {
  den.aspects.applications.security.keepassxc = {
    homeManager =
      { host, lib, ... }:
      {
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
              MinimizeOnStartup = true;
              ShowTrayIcon = true;
              TrayIconAppearance = "monochrome-light";
            };
            PasswordGenerator = {
              Length = 64;
            };
            SSHAgent = {
              Enabled = false;
            };
          };
        };
      }
      // lib.optionalAttrs (host.hasAspect den.aspects.desktop.hyprland) {
        wayland.windowManager.hyprland.settings.window_rule = lib.mkMerge [
          [
            {
              match.class = "^(org\\.keepassxc\\.KeePassXC)$";
              tag = "+floating";
            }
          ]
          (lib.mkAfter [
            {
              match.class = "^(org\\.keepassxc\\.KeePassXC)$";
              size = [
                920
                620
              ];
            }
          ])
        ];
      };

    persistHome.directories = [
      ".local/state/keepassxc"
    ];
  };
}
