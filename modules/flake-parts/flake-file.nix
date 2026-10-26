{ inputs, ... }: {

  imports = [
    inputs.flake-file.flakeModules.dendritic
  ];

  flake-file = {
    description = ''
      My personal nix flake, heavily inspired by sini's nix config.
    '';

    prune-lock.enable = true;

    inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

      apple-fonts = {
        url = "github:Lyndeno/apple-fonts.nix";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      den.url = "github:denful/den";
      files.url = "github:sini/files";
      flake-compat.url = "github:edolstra/flake-compat";
      gen-schema.url = "github:sini/gen-schema";

      git-hooks-nix = {
        url = "github:cachix/git-hooks.nix";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      home-manager = {
        url = "github:nix-community/home-manager/release-26.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      home-manager-unstable = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      import-tree.url = "github:vic/import-tree";

      nix-gaming.url = "github:fufexan/nix-gaming";

      nix-wrapper-modules = {
        url = "github:BirdeeHub/nix-wrapper-modules";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
    };
  };
}
