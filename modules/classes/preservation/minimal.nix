{ den, inputs, ... }:  
{  
  den.aspects.preservation = {  
    includes = [ den.batteries.preservation-forward ];  
  
    nixos = {  
      imports = [ inputs.preservation.nixosModules.default ];  
  
      boot.tmp.cleanOnBoot = true;  
      boot.tmp.useTmpfs = true;  
      
      fileSystems."/nix".neededForBoot = true;
      fileSystems."/persistent".neededForBoot = true;
      
      users.mutableUsers = false;
  
      systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];  
  
      preservation = {  
        enable = true;  
        preserveAt."/persistent" = {  
          directories = [  
            "/etc/NetworkManager/system-connections"  
            "/var/db/sudo/lectured"  
            "/var/lib/systemd/timers"
            "/var/lib/systemd/backlight"
            "/var/log"  
            { directory = "/var/lib/nixos"; inInitrd = true; }  
          ];
          
          files = [  
            { file = "/etc/machine-id"; inInitrd = true; }  
            { file = "/var/lib/systemd/random-seed"; how = "symlink"; inInitrd = true; configureParent = true; }  
          ];  
        };  
      };  
    };  
  };  
}
