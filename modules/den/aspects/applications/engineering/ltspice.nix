{
  den.aspects.applications.engineering.ltspice = {
    homeManager = { pkgs, ... }: {
      home.packages = [
        pkgs.local.ltspice
      ];
    };

    persistHome.directories = [
      ".local/share/wineprefixes/ltspice"
    ];
  };
}
