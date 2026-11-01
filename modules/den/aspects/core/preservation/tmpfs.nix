{
  den.aspects.core.preservation.tmpfs = {
    nixos = _: {
      boot.tmp = {
        useTmpfs = true;
        cleanOnBoot = true;
      };
    };
  };
}
