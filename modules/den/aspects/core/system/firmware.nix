{
  den.aspects.core.system.firmware = {
    nixos = {
      hardware.enableRedistributableFirmware = true;
      services.fwupd.enable = true;
    };

    persist.directories = [
      "/var/lib/fwupd"
    ];

    cache.directories = [
      "/var/cache/fwupd"
    ];
  };
}
