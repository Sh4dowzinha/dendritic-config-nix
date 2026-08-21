{ den, lib, ... }:  
{  
  den.batteries.preservation-forward = { class, aspect-chain }: den.batteries.forward {  
    each = lib.optional (class != "preservation-class") true;  
    fromClass = _item: "preservation-class";  
    intoClass = _item: class;  
    intoPath = _item: [ "preservation" "preserveAt" "/persistent" ];  
    fromAspect = _item: lib.head aspect-chain;  
    guard = { options, ... }: options ? preservation.preserveAt;  
  };  
}
