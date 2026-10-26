{
  den.aspects.core.systemd.boot = {
    nixos = {
      boot = {
        loader = {
          systemd-boot = {
            enable = true;
          };
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
          };
        };
      };
    };
  };
}
