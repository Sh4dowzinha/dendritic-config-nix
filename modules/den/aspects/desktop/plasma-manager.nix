{
  flake-file.inputs.plasma-manager = {
    url = "github:nix-community/plasma-manager";
    inputs = {
      nixpkgs.follows = "nixpkgs-unstable";
      home-manager.follows = "home-manager-unstable";
    };
  };

  den.aspects.desktop.plasma-manager = {
    # TODO
  };
}
