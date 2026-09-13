{
  flake-file.inputs.plasma-manager = {
    url = "github:nix-community/plasma-manager";
    inputs = {
      nixpkgs.follows = "nixpkgs-unstable";
      home-manager.follows = "home-manager-unstable";
    };
  };

  den.aspects.desktop.kde = {
    nixos = {
      services.desktopManager.plasma6.enable = true;
      services.displayManager.plasma-login-manager = {
        enable = true;
      };
    };

    homeManagerModules =
      { inputs', ... }:
      [
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

    persistHome = {
      directories = [
        {
          directory = ".local/share/kwalletd";
          mode = "0700";
        }
      ];
    };

    cacheHome = {
      directories = [
        ".local/share/baloo/"
      ];
    };
  };
}
