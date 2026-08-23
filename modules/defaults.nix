{ lib, den, ... }: {
  den.default = {
    includes = [
      den.batteries.define-user
      den.batteries.hostname
      den.batteries.inputs'
    ];
    
    nixos = {
      nix = {
        settings = {
          experimental-features = [ "nix-command" "flakes" ];
        };
        
        optimise = {
          automatic = true;
          dates = [ "03:45" ];
        };
      };

      nixpkgs.config.allowUnfree = true;
      system.stateVersion = "26.05";
      
      programs.appimage = {
        enable = true;
        binfmt = true;
      };
    };

    homeManager.home.stateVersion = "26.05";
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
