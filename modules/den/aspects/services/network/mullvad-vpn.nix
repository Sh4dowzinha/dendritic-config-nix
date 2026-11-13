{
  den.aspects.services.network.mullvad-vpn = {
    nixos =
      { pkgs, ... }:
      let
        mullvad-autostart = pkgs.makeAutostartItem {
          name = "mullvad-vpn";
          package = pkgs.mullvad-vpn;
        };
      in
      {
        environment.systemPackages = [ mullvad-autostart ];
        services.mullvad-vpn = {
          enable = true;
          gui.enable = true;
          enableEarlyBootBlocking = true;
          enableExcludeWrapper = true;
        };
      };

    persist.directories = [
      {
        directory = "/etc/mullvad-vpn";
        mode = "0700";
      }
    ];

    persistHome.directories = [
      ".config/Mullvad VPN"
    ];

    cache.directories = [
      {
        directory = "/var/cache/mullvad-vpn";
        mode = "0700";
      }
    ];
  };
}
