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
            readOnly = true;
          };
          userDirs.enable = true;
        };
      };
  };
}
