{
  flake-file.inputs.nix-gaming.url = "github:fufexan/nix-gaming";

  den.aspects.applications.gaming.defaults = {
    nixos =
      {
        lib,
        resolved-users ? [ ],
        ...
      }:
      let
        userNames = map (u: u.name or u.userName) resolved-users;
      in
      {
        nix.settings = {
          substituters = [ "https://nix-gaming.cachix.org" ];
          trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
        };

        # Disable the "misery mode" delay penalty & synchronization
        boot = {
          kernel.sysctl = {
            "kernel.split_lock_mitigate" = 0;
            "vm.max_map_count" = 2147483642;
          };
          kernelParams = [
            # And / Or disable split-lock detection entirely (also prevents the default "warn" log entries)
            "split_lock_detect=off" # accepts: off|warn|fatal|ratelimit:N (0 < N <= 1000)
          ];
        };

        users.users = lib.genAttrs userNames (_: {
          extraGroups = [ "gamemode" ];
        });

        programs.gamemode = {
          enable = true;
        };
      };

    nix-ld-libraries = { pkgs, ... }: (pkgs.steam-run.args.multiPkgs pkgs);
  };
}
