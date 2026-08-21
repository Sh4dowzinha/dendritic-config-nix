{ den, ... }: {
  den.aspects.base-system = {
    includes = with den.aspects; [
      systemd-boot
      zram
      firmware
      pipewire
      nh
      firewall
      dns
      networkManager
    ];

    nixos = { pkgs, ... }: {
      hardware.i2c.enable = true;
      
      environment.systemPackages = with pkgs; [
        wget
        tree
      ];
    };
  };
}
