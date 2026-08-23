{ inputs, ... }:
{
  den.aspects.claude-code = {
    nixos.nixpkgs.overlays = [ inputs.claude-code.overlays.default ];

    homeManager = { pkgs, ... }: {
      nix.settings = {
        substituters = [ "https://claude-code.cachix.org" ];
        trusted-public-keys = [ "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk=" ];
      };

      home.packages = [ pkgs.claude-code ];
    };
  };
}
