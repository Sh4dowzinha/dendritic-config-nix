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
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      ayugram-desktop.url = "github:ndfined-crp/ayugram-desktop";

      base16-schemes = {
        url = "github:tinted-theming/schemes";
        flake = false;
      };

      betterfox = {
        url = "github:yokoffing/Betterfox";
        flake = false;
      };

      den.url = "github:denful/den";

      devshell = {
        url = "github:numtide/devshell";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      disko = {
        url = "github:nix-community/disko";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      files.url = "github:sini/files";

      firefox-addons = {
        url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      flake-compat = {
        url = "github:edolstra/flake-compat";
      };

      flake-file.url = "github:vic/flake-file";

      flake-parts = {
        url = "github:hercules-ci/flake-parts";
        inputs.nixpkgs-lib.follows = "nixpkgs-unstable";
      };

      gen-schema.url = "github:sini/gen-schema";

      git-hooks-nix.url = "github:cachix/git-hooks.nix";

      home-manager = {
        url = "github:nix-community/home-manager/release-26.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      home-manager-stable-darwin = {
        url = "github:nix-community/home-manager/release-26.05";
        inputs.nixpkgs.follows = "nixpkgs-stable-darwin";
      };

      home-manager-unstable = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      hyprland.url = "github:hyprwm/Hyprland";

      hyprland-plugins = {
        url = "github:hyprwm/hyprland-plugins";
        inputs.hyprland.follows = "hyprland";
      };

      import-tree.url = "github:vic/import-tree";

      noctalia.url = "github:noctalia-dev/noctalia/cachix";

      nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

      nix-darwin = {
        url = "github:LnL7/nix-darwin/nix-darwin-26.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nix-darwin-unstable = {
        url = "github:LnL7/nix-darwin";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      nix-flatpak.url = "github:gmodena/nix-flatpak";

      nix-gaming.url = "github:fufexan/nix-gaming";

      nix-index-database = {
        url = "github:nix-community/nix-index-database";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      nix-vscode-extensions = {
        url = "github:nix-community/nix-vscode-extensions";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      nix-wrapper-modules = {
        url = "github:BirdeeHub/nix-wrapper-modules";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      nixcord.url = "github:kaylorben/nixcord";

      nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

      nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";

      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

      nvf.url = "github:notashelf/nvf";

      pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";

      preservation.url = "github:nix-community/preservation";

      proton-cachyos.url = "github:powerofthe69/proton-cachyos-nix";

      shimmer = {
        url = "github:nuclearcodecat/shimmer";
        flake = false;
      };

      steam-config-nix = {
        url = "github:different-name/steam-config-nix";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      stylix = {
        url = "github:nix-community/stylix";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      treefmt-nix = {
        url = "github:numtide/treefmt-nix";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      zen-browser = {
        url = "github:0xc000022070/zen-browser-flake";
        inputs = {
          nixpkgs.follows = "nixpkgs-unstable";
          home-manager.follows = "home-manager-unstable";
        };
      };
    };
  };
}
