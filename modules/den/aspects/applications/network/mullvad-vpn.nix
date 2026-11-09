{
  den.aspects.applications.network.mullvad-vpn = {
    nixos = _: {
      services.mullvad-vpn = {
        enable = true;
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

    cache.directories = [
      {
        directory = "/var/cache/mullvad-vpn";
        mode = "0700";
      }
    ];
  };
}
