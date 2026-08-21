{ den, ... }: {
  den.aspects.nh = {
    nixos = {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep 5 --keep-since 14d";
          dates = "weekly";
        };
      };
    };
  };
}
