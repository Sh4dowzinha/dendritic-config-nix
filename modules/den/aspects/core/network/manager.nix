{
  den.aspects.core.network.manager = {
    nixos =
      {
        pkgs,
        ...
      }:
      {
        networking.networkmanager = {
          enable = true;
          dns = "systemd-resolved";
          settings = {
            connectivity = {
              enabled = false;
            };
          };
          plugins = [
            pkgs.networkmanager-openvpn
          ];
        };
      };

    persist.directories = [
      "/etc/NetworkManager/system-connections"
    ];
  };
}
