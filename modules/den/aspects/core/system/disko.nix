{ inputs, ... }:
{
  flake-file.inputs = {
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.core.system.disko = {
    nixos = {
      imports = [ inputs.disko.nixosModules.disko ];
    };
  };
}
