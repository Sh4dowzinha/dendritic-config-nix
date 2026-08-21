{
  den.aspects.firmware-all.nixos = {
    services.fwupd.enable = true;
    hardware.enableAllFirmware = true;
    hardware.enableRedistributableFirmware = true;
    nixpkgs.config.allowUnfree = true;
  };
}
