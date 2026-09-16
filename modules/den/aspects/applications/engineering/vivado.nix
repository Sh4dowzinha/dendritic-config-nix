{
  den.aspects.applications.engineering.vivado = {
    homeManager = { pkgs, ... }: {
      home.packages = [
        pkgs.local.vivado
      ];
    };
  };
}
