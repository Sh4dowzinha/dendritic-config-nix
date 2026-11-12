{
  den.aspects.applications.engineering.vivado = {
    nixos =
      {
        config,
        host,
        ...
      }:
      {
        sops.secrets.vivadoLicense = {
          key = "vivadoLicense";
          owner = host.system-owner;
          group = host.system-owner;
          mode = "0400";
        };

        environment.sessionVariables = {
          XILINXD_LICENSE_FILE = config.sops.secrets.vivadoLicense.path;
        };
      };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.local.vivado
        ];
      };

    persistHome.directories = [
      ".Xilinx/Vivado/2026.1"
    ];
  };
}
