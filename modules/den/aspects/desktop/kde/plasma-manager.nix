{
  flake-file.inputs = {
    plasma-manager-unstable = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        home-manager.follows = "home-manager-unstable";
      };
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  den.aspects.desktop.plasma-manager = { host, ... }: {
    homeManagerModules = { inputs', ... }: [
      (
        if host.channel == "nixos-unstable" then
          inputs'.plasma-manager-unstable.homeModules.plasma-manager
        else
          inputs'.plasma-manager.homeModules.plasma-manager
      )
    ];

    homeManager = {
      programs.plasma = {
        enable = true;
        immutableByDefault = true;
        overrideConfig = true;

        configFile = {
          "baloofilerc" = {
            "Basic Settings" = {
              "Indexing-Enabled" = {
                value = false;
              };
            };
          };
        };

        workspace = {
          lookAndFeel = "org.kde.breezedark.desktop";
        };
      };
    };
  };
}
