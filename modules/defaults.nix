{ lib, den, ... }: {
  den.default = {
    includes = [
      den.batteries.define-user
      den.batteries.hostname
      den.batteries.inputs'
    ];
    
    nixos.system.stateVersion = "26.05";
    homeManager.home.stateVersion = "26.05";
    
    nixos = {
      nix = {
        settings = {
          experimental-features = [ "nix-command" "flakes" ];
          max-substitution-jobs = 1;
        };
        
        optimise = {
          automatic = true;
          dates = [ "03:45" ];
        };
      };

      nixpkgs.config.allowUnfree = true;
      
      programs.appimage = {
        enable = true;
        binfmt = true;
      };
    };
  };

  # Enable hm by default
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
  
  # HomeManager default settings
  den.schema.hm-host.includes = [  
    { 
      nixos.home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
      };
    }  
  ];
}
