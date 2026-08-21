{ den, ... }: {

  den.aspects.sh4dow = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      den.batteries.host-aspects
      (den.batteries.user-shell "bash")
    ];
    
    user.extraGroups = [ "i2c" ];

    homeManager = { pkgs, ... }: {
      programs.git = {
        enable = true;
        settings = {
          core.editor = "vim";
          user = {
            name  = "André Fernandes";
            email = "andrematosf727@gmail.com";
          };
          
          init.defaultBranch = "main";
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
