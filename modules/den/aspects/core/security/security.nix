{
  den.aspects.core.security = {
    nixos = {
      security = {
        polkit = {
          enable = true;
          enablePkexecWrapper = true;
        };

        tpm2.enable = true;
      };
    };
  };
}
