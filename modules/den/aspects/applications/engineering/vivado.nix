{
  den.aspects.applications.engineering.vivado = {
    homeManager = { pkgs, ... }: {
      home.packages = [
        pkgs.local.vivado
      ];
    };

    persistHome.directories = [
      ".Xilinx/Vivado/2026.1"
    ];
  };
}
