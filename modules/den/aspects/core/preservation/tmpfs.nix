{
  den.aspects.core.preservation.tmpfs = {
    nixos = {
      boot.tmp = {
        useTmpfs = true;
        cleanOnBoot = true;
      };
    };
  };
}
