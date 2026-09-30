{
  den.aspects.hardware.nbfc = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        nbfc-linux
      ];
    };
  };
}
