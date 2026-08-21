{
  den.aspects.systemd-boot.nixos = {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
