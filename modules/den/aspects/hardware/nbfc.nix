{
  den.aspects.hardware.nbfc = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        nbfc-linux
      ];
    };
  };
}
