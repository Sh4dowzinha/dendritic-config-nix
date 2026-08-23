{ den, ... }: {

  den.aspects.sh4dow = {
    includes = [
      # Den batteries
      den.batteries.define-user
      den.batteries.primary-user
      den.batteries.host-aspects
      (den.batteries.user-shell "bash")

      # Den aspects
      den.aspects.ssh.client-config
      den.aspects.shell.fish
      den.aspects.vesktop
      den.aspects.localsend
      den.aspects.gpg
      den.aspects.claude-code
    ];
    
    user.extraGroups = [ "i2c" ];

    homeManager = { pkgs, ... }: {
      home.sessionVariables = {
        EDITOR = "vim";
      };
      
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
