{ den, ... }: {
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
      {
        host,
        lib,
        pkgs,
        ...
      }:
      {
        home.packages = [
          pkgs.local.vivado
        ];
      }
      // lib.optionalAttrs (host.hasAspect den.aspects.desktop.hyprland) {
        wayland.windowManager.hyprland.settings.window_rule = [
          {
            match.class = "^(Vivado|java-lang-Thread)$";
            tag = "+crisp";
          }
          {
            match = {
              class = "^(Vivado|java-lang-Thread)$";
              title = "^(splash)$";
            };
            tag = "+floating";
          }
        ];
      };

    persistHome.directories = [
      ".Xilinx/Vivado/2026.1"
    ];
  };
}
