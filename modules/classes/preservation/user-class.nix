{ den, lib, ... }:  
{  
  den.aspects.preservation.provides.for-users = {  
    includes = [  
      (  
        { host, user }:  
        { class, aspect-chain }:  
        den.batteries.forward {  
          each = lib.singleton true;  
          fromClass = _item: "preservation-user-class";  
          intoClass = _item: host.class;  
          intoPath = _item: [ "preservation" "preserveAt" "/persistent" "users" user.userName ];  
          fromAspect = _item: lib.head aspect-chain;  
          guard =  
            { options, ... }:  
            if options ? preservation.preserveAt then  
              true  
            else  
              throw ''  
                den: user "${user.userName}" on host "${host.name}" uses preservation-user-class,  
                but host "${host.name}" does not include den.aspects.preservation  
                (preservation.preserveAt is not defined). Include den.aspects.preservation  
                on the host before assigning per-user preservation directories.  
              '';  
        }  
      )  
    ];
    
    preservation-user-class = {  
      commonMountOptions = [ "x-gvfs-hide" ];  
      directories = [  
        "Desktop"  
        "Documents"  
        "Downloads"  
        "Music"  
        "Pictures"  
        "Projects"  
        "Public"  
        "Templates"  
        "Videos"  
        ".config/autostart"
      ];  
    };  
  };  
}
