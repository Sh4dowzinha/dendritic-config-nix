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
        ];

        networking.networkmanager.wifi = {
          powersave = true;
          macAddress = "preserve";
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

          scx = {
            enable = true;
            package = lib.mkForce pkgs.scx.full;
            scheduler = lib.mkForce "scx_lavd";
            extraArgs = [
              "--autopower"
            ];
          };

          auto-cpufreq = {
            enable = true;
            settings = {
              battery = {
                governor = "powersave";
                energy_performance_preference = lib.mkDefault "balance_power";
                turbo = "never";
              };
              charger = {
                governor = "powersave";
                energy_performance_preference = lib.mkDefault "balance_performance";
                turbo = "auto";
              };
            };
          };

          thermald.enable = true;
        };
      };
  };
}
