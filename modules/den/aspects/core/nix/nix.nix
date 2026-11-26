{ lib, ... }:
{
  den.aspects.core.nix = {
    nixos = {
      nix = {
        channel.enable = false;

        settings = {
          experimental-features = [
            "auto-allocate-uids"
            "cgroups"
            "flakes"
            "nix-command"
            "pipe-operators"
          ];

          auto-allocate-uids = true;
          use-cgroups = true;
          allow-import-from-derivation = false;
          max-jobs = "auto";
          use-xdg-base-directories = true;
          max-substitution-jobs = 16;
          auto-optimise-store = false;
          warn-dirty = false;
          keep-outputs = true;
          keep-derivations = true;

          substituters = [
            "https://cache.nixos.org/"
            "https://nix-community.cachix.org"
            "https://numtide.cachix.org"
          ];

          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
          ];

          # trusted-users grants root-equivalent nix power (override settings,
          # add substituters, import untrusted store paths) — admins only.
          trusted-users = [
            "root"
            "@wheel"
          ];

          # allowed-users only gates who may connect to the daemon; every local
          # login user needs it (HM activation, nix-shell). With mutableUsers = false,
          # local accounts are exactly the resolved registry users.
          allowed-users = [ "*" ];

          connect-timeout = 5;
          builders-use-substitutes = true;
          sandbox = true;
          fallback = true;
        };

        gc = {
          automatic = lib.mkDefault true;
          dates = lib.mkDefault "05:00";
          randomizedDelaySec = lib.mkDefault "45min";
          options = lib.mkDefault "--delete-older-than 8d";
        };

        optimise = {
          automatic = lib.mkDefault true;
          dates = lib.mkDefault [ "weekly" ];
          randomizedDelaySec = lib.mkDefault "45min";
        };
      };
    };
  };
}
