{ lib, inputs, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.channels = mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          nixpkgs = mkOption {
            type = types.raw;
            description = "The nixpkgs flake input for this channel.";
          };
          home-manager = mkOption {
            type = types.raw;
            description = "The home-manager flake input for this channel.";
          };
        };
      }
    );
    description = "Mapping of channel names to their nixpkgs and home-manager flake inputs.";
  };

  config.channels = {
    nixos-stable = {
      inherit (inputs) nixpkgs;
      inherit (inputs) home-manager;
    };
    nixos-unstable = {
      nixpkgs = inputs.nixpkgs-unstable;
      home-manager = inputs.home-manager-unstable;
    };
  };
}
