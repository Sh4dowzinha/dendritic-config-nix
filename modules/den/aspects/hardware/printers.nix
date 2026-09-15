{ den, ... }: {
  den.aspects.hardware.printers = {
    include = [ den.aspects.core.network.avahi ];
    nixos = { pkgs, ... }: {
      services.printing = {
        enabled = true;
        startWhenNeeded = true;
        stateless = true;
        drivers = with pkgs; [
          hplip
        ];
      };
    };
  };
}
