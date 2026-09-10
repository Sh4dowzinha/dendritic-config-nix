# Host entity schema — channels, networking, settings, computed fields.
#
# Follows feat/den's approach: channels defined inline, instantiate/HM module
# derived from config.channel, dynamic settings namespace from den.aspects,
# computed ipv4/ipv6 from networking interfaces.
{
  lib,
  inputs,
  den,
  rootPath,
  ...
}:
let
  inherit (lib) mkOption types;
  schemaLib = inputs.gen-schema.lib;

  # Channel definitions — maps channel name to nixpkgs/HM/darwin inputs
  channels = {
    nixos-unstable = {
      nixosSystem = inputs.nixpkgs-unstable.lib.nixosSystem;
      darwinSystem = inputs.nix-darwin-unstable.lib.darwinSystem;
      home-manager-module.nixos = inputs.home-manager-unstable.nixosModules.home-manager;
      home-manager-module.darwin = inputs.home-manager-unstable.darwinModules.home-manager;
    };
    nixos-stable = {
      nixosSystem = inputs.nixpkgs.lib.nixosSystem;
      darwinSystem = inputs.nix-darwin.lib.darwinSystem;
      home-manager-module.nixos = inputs.home-manager.nixosModules.home-manager;
      home-manager-module.darwin = inputs.home-manager.darwinModules.home-manager;
    };
    nixpkgs-stable-darwin = {
      nixosSystem = inputs.nixpkgs-stable-darwin.lib.nixosSystem;
      darwinSystem = inputs.nix-darwin.lib.darwinSystem;
      home-manager-module.nixos = inputs.home-manager-stable-darwin.nixosModules.home-manager;
      home-manager-module.darwin = inputs.home-manager-stable-darwin.darwinModules.home-manager;
    };
  };

  channelNames = builtins.attrNames channels;

  # Dynamic settings type — recursively discovers aspects that declare .settings.
  # Mirrors the aspect tree: den.aspects.disk.zfs-disk-single.settings →
  # host.settings.disk.zfs-disk-single.*  (shared with the cluster schema).
  settingsType = import ./_settings-type.nix { inherit den lib; };
in
{
  den.schema.host.isEntity = true;

  den.schema.host.validators = [
    (schemaLib.mkValidator "valid-channel" (
      { channel, ... }: lib.elem channel channelNames
    ) "channel must be one of: ${lib.concatStringsSep ", " channelNames}")
  ];

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
            description = "Nixpkgs channel — determines nixpkgs, home-manager, and nix-darwin versions";
          };

          system-owner = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Primary user for this host";
          };

          facts =
            mkOption {
              type = types.nullOr types.path;
              default = null;
            }
            // {
              identity = false;
            };

          # Dynamic settings namespace — auto-discovers aspects with .settings
          settings =
            mkOption {
              type = settingsType;
              default = { };
              description = "Per-aspect typed settings";
            }
            // {
              identity = false;
            };
        };

        # Computed config — channel determines instantiate + HM module
        config = {
          # rootPath (a `../..` path literal), NOT `self`: these defaults are
          # forced during base eval by the producer-class config-thunk broadcast
          # (a host config is navigated to reach a nested home config), where
          # `self` self-cycles (registry → self → flake outputs → registry).
          # Same git-tracked source as `self`; mirrors `user.secretPath`.
          facts = lib.mkDefault (rootPath + "/hosts/${config.name}/facter.json");

          instantiate = lib.mkDefault (
            if config.class == "darwin" then resolvedChannel.darwinSystem else resolvedChannel.nixosSystem
          );

          home-manager.module = lib.mkDefault (
            if config.class == "darwin" then
              resolvedChannel.home-manager-module.darwin
            else
              resolvedChannel.home-manager-module.nixos
          );
        };
      }
    )
  ];
}
