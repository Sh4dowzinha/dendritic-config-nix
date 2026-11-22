{
  den.aspects.desktop.uwsm = {
    nixos = { pkgs, ... }: {
      programs.uwsm.enable = true;

      environment = {
        systemPackages = [ pkgs.app2unit ];
        sessionVariables = {
          APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
          APP2UNIT_TYPE = "scope";
        };
      };
    };

    homeManager = { config, ... }: {
      xdg.configFile."uwsm/env".source =
        "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
    };
  };
}
