{
  den.aspects.desktop.uwsm = {
    nixos =
      { pkgs, ... }:
      {
        programs.uwsm.enable = true;

        environment = {
          systemPackages = [ pkgs.app2unit ];
          sessionVariables = {
            NIXOS_OZONE_WL = "1";
            APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
            APP2UNIT_TYPE = "scope";
          };
        };
      };
  };
}
