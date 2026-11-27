{
  inputs,
  ...
}:
let
  config = {
    allowUnfree = true;
  };
in
{
  den.aspects.core.nix.nixpkgs = {
    # Shared base overlays, contributed through the nixpkgs-overlays quirk so os
    # and home-manager collect them the same way as every other overlay.
    #
    # `local` is rebuilt from den's `self'.packages` rather than referencing
    # `self.overlays.default` to avoid re-entering the flake `outputs` fixpoint.
    nixpkgs-overlays =
      { self', ... }:
      [
        (_final: _prev: { local = self'.packages; })
        (final: _prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit (final.stdenv.hostPlatform) system;
            inherit (final) config;
          };
        })
      ];

    nixos =
      {
        nixpkgs-overlays ? [ ],
        lib,
        ...
      }:
      {
        nixpkgs = {
          inherit config;
          overlays = lib.flatten nixpkgs-overlays;
        };
      };

    # Only applies when useGlobalPkgs = false; otherwise Home Manager inherits
    # the host's pkgs and setting nixpkgs.* here trips HM's assertion.
    homeManager =
      {
        host,
        nixpkgs-overlays ? [ ],
        lib,
        ...
      }:
      lib.optionalAttrs (!(host.settings.core.users.home-manager-shared.useGlobalPkgs or true)) {
        nixpkgs = {
          inherit config;
          overlays = lib.flatten nixpkgs-overlays;
        };
      };
  };
}
