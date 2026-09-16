{
  den.aspects.hardware.laptop = {

    persist = {
      directories = [
        "/var/lib/upower"
      ];
    };

    nixos =
      { pkgs, lib, ... }:
      {
        environment.systemPackages = [
          pkgs.brightnessctl
          pkgs.powertop
        ];

        networking.networkmanager.wifi = {
          powersave = true;
          macAddress = "stable-ssid";
        };

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

          power-profiles-daemon.enable = false;
          upower.enable = true;

          tlp = {
            enable = true;
            pd.enable = true;
            settings = {
              MAX_LOST_WORK_SECS_ON_BAT = 15;
              USB_AUTOSUSPEND = 0;
            };
          };

          scx = {
            enable = true;
            package = lib.mkForce pkgs.scx.full;
            scheduler = lib.mkForce "scx_lavd";
            extraArgs = [
              "--autopower"
            ];
          };
        };
      };
  };
}
