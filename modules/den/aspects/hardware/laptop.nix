{
  den.aspects.hardware.laptop = {
    persist = {
      directories = [
        "/var/lib/upower"

        # Powertop calibration parameters should survive /cache wipes
        {
          directory = "/var/cache/powertop";
          mode = "0700";
        }
      ];
    };

    nixos =
      { pkgs, lib, ... }:
      {
        environment.systemPackages = with pkgs; [
          brightnessctl
          powertop
        ];

        services = {
          logind.settings.Login = {
            HandleLidSwitch = "suspend";
            HandleLidSwitchExternalPower = "ignore";
            HandleLidSwitchDocked = "ignore";
            HandlePowerKey = "suspend";
            HandleSuspendKey = "suspend";
            HandleHibernateKey = "suspend";
            PowerKeyIgnoreInhibited = "yes";
            SuspendKeyIgnoreInhibited = "yes";
            HibernateKeyIgnoreInhibited = "yes";
          };

          # tlp-pd implements the power-profiles-daemon D-Bus API for Noctalia & KDE
          power-profiles-daemon.enable = lib.mkForce false;
          upower.enable = true;

          tlp = {
            enable = true;
            pd.enable = true;
            settings = {
              MAX_LOST_WORK_SECS_ON_BAT = 15;
              USB_AUTOSUSPEND = 0;
            };
          };

          scx-loader = {
            enable = true;
            config = {
              default_sched = "scx_lavd";
              default_mode = "Auto";

              scheds.scx_lavd = {
                autoMode = [ "--autopower" ];
                gamingMode = [ "--performance" ];
                lowLatencyMode = [ "--performance" ];
                powersaveMode = [ "--powersave" ];
                serverMode = [ "--performance" ];
              };
            };
          };
        };
      };
  };
}
