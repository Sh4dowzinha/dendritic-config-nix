{
  den.aspects.applications.dev.vivado = {
    homeLinux = { pkgs, ... }: {
      home.packages = [
        pkgs.local.vivado
      ];
    };
  };
}
