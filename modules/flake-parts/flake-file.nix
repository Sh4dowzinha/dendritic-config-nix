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
      apple-fonts = {
        url = "github:Lyndeno/apple-fonts.nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      base16-schemes = {
        url = "github:tinted-theming/schemes";
        flake = false;
      };

      den.url = "github:denful/den";

      files.url = "github:sini/files";

      flake-compat = {
        url = "github:edolstra/flake-compat";
      };

      gen-schema.url = "github:sini/gen-schema";

      git-hooks-nix.url = "github:cachix/git-hooks.nix";

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

      nix-index-database = {
        url = "github:nix-community/nix-index-database";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nix-wrapper-modules = {
        url = "github:BirdeeHub/nix-wrapper-modules";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

      # temporary pin to the nixpkgs version before
      # the kernel modules regression
      #nixpkgs-unstable.url = "github:nixos/nixpkgs/fe13242281a67641c0102cdb1087f0ebe586c7df";

      pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";

      treefmt-nix = {
        url = "github:numtide/treefmt-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
  };
}
