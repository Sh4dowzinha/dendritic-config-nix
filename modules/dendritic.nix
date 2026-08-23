{ inputs, ... }: {
  
  imports = [
    inputs.flake-file.flakeModules.dendritic
    inputs.den.flakeModules.dendritic
  ];

  flake-file.inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
#    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    den.url = "github:denful/den";
    flake-file.url = "github:vic/flake-file";
    
#    sops-nix = {
#      url = "github:Mic92/sops-nix";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };
    
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
#    plasma-manager = {
#      url = "github:nix-community/plasma-manager";
#      inputs.nixpkgs.follows = "nixpkgs";
#      inputs.home-manager.follows = "home-manager";
#    };
    
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    claude-code.url = "github:sadjow/claude-code-nix";
    
    preservation.url = "github:nix-community/preservation";
  };
}
