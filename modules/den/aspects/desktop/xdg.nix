{
  den.aspects.desktop.xdg = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.xdg-utils
        ];

        xdg = {
          enable = true;
          autostart = {
            enable = true;
            # readOnly = true;   # Keep disabled for now
          };
          userDirs.enable = true;
        };
      };
  };
}
