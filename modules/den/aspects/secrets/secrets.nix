{
  flake-file.inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  #  den.aspects.core.secrets = {
  #    nixos = {
  #    };

  #    persist = {
  #      directories = [
  #      ];
  #    };
  #  };
}
