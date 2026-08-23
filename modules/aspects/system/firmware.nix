{
  den.aspects.firmware.nixos = {
    services.fwupd.enable = true;
    hardware.enableRedistributableFirmware = true;
    nixpkgs.config.allowUnfree = true;
  };
}
