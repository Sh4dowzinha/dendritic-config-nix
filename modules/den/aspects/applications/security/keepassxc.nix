{ den, ... }:
{
  den.aspects.applications.security.keepassxc = {
    includes = [
      den.aspects.desktop.xdg
    ];
    homeManager = {
      programs.keepassxc = {
        enable = true;
        autostart = true;
      };
    };

    persistHome = {
      directories = [
        {
          directory = ".config/keepassxc";
        }
      ];
    };
  };
}
