{ den, ... }: {

  den.aspects.sh4dow = {
    includes = [
      # Den batteries
      den.batteries.primary-user
      (den.batteries.user-shell "fish")

      # Den aspects
      den.aspects.trusted-user
      den.aspects.ssh.client-config
      den.aspects.git
      den.aspects.nitrokey3
      den.aspects.fish
      den.aspects.vesktop
      den.aspects.localsend
      den.aspects.nh
      den.aspects.steam
      den.aspects.claude-code
      den.aspects.gpg
      den.aspects.fastfetch
    ];
    
    user.extraGroups = [ "i2c" ];

    homeManager = { pkgs, ... }: {
      
      home.sessionVariables = {
        EDITOR = "vim";
      };
      
      programs.git = {
        settings = {
          core.editor = "vim";
          user = {
            name  = "André Fernandes";
            email = "andrematosf727@gmail.com";
          };
          
          commit.gpgsign = true;
          tag.gpgsign = true;
        };
      };

      programs.gpg.publicKeys = [
        {
          source = ./pubkeys/personal.asc;
          trust = 5; 
        }
      ];
    };
    
    # Hacky way of dealing with preservation
    provides.novacustom.user = {
      hashedPasswordFile = "/persistent/passwd/sh4dow";
      # initialPassword = "12345";
    };
  };
}
