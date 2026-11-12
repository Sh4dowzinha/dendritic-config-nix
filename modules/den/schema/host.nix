{
  lib,
  inputs,
  den,
  rootPath,
  ...
}:
let
  inherit (lib) mkOption types;
  settingsType = import (rootPath + "/modules/den/lib/_settings-type.nix") { inherit den lib; };

  # Channel definitions — maps channel name to nixpkgs/HM inputs
  channels = {
    nixos-unstable = {
      nixosSystem = inputs.nixpkgs-unstable.lib.nixosSystem;
      home-manager-module.nixos = inputs.home-manager-unstable.nixosModules.home-manager;
    };
    nixos-stable = {
      nixosSystem = inputs.nixpkgs.lib.nixosSystem;
      home-manager-module.nixos = inputs.home-manager.nixosModules.home-manager;
    };
  };

  channelNames = builtins.attrNames channels;
in
{
  den.schema.host.isEntity = true;

  den.schema.host.imports = [
    (
      { config, ... }:
      let
        resolvedChannel = channels.${config.channel};
      in
      {
        options = {
          channel = mkOption {
            type = types.enum channelNames;
            default = "nixos-unstable";
            description = "Nixpkgs channel — determines nixpkgs and home-manager versions";
          };

          system-owner = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Primary user for this host";
          };

          facts = mkOption {
            type = types.nullOr types.path;
            default = null;
          };

          # Dynamic settings namespace — auto-discovers aspects with .settings
          settings = mkOption {
            type = settingsType;
            default = { };
            description = "Per-aspect typed settings";
          };
        };

        config = {
          facts =
            let
              factsPath = rootPath + "/hosts/${config.name}/facter.json";
            in
            lib.mkDefault (if builtins.pathExists factsPath then factsPath else null);

          instantiate = lib.mkDefault resolvedChannel.nixosSystem;
          home-manager.module = lib.mkDefault resolvedChannel.home-manager-module.nixos;
        };
      }
    )
  ];
}
