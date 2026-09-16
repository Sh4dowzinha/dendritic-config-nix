{
  den.aspects.desktop.noctalia = {
    nixos = {
      nix.settings = {
        extra-substituters = [ "https://noctalia.cachix.org" ];
        extra-trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
    };

    homeManagerModules =
      { inputs', ... }:
      [
        inputs'.noctalia.homeModules.default
      ];

    homeManager = { ... }: {
      programs.noctalia = {
        enable = true;
        systemd.enable = true;

        settings = {
          shell = {
            launch_apps_as_systemd_services = true;
          };

          theme = {
            mode = "dark";
            source = "builtin";
            builtin = "Catppuccin";
          };
        };
      };
    };
  };
}
