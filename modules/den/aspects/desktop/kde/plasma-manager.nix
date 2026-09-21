{
  flake-file.inputs.plasma-manager = {
    url = "github:nix-community/plasma-manager";
    inputs = {
      nixpkgs.follows = "nixpkgs-unstable";
      home-manager.follows = "home-manager-unstable";
    };
  };

  den.aspects.desktop.kde = {
    homeManagerModules = { inputs', ... }: [
      inputs'.plasma-manager.homeModules.plasma-manager
    ];

    homeManager = {
      programs.plasma = {
        enable = true;
        overrideConfig = true;

        workspace = {
          lookAndFeel = "org.kde.breezedark.desktop";
        };
      };
    };
  };
}
