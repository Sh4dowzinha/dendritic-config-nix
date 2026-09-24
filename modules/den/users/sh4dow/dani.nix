{ den, ... }:
{
  den.aspects.dani = {
    includes = [ den.batteries.host-aspects ];
  };

  den.users.registry.dani = {
    system.uid = 1000;
    groups = [
      "admins"
    ];

    identity = {
      displayName = "Daniel Alves";
      email = "placeholder";

      # sshKeys = [
      #   {
      #     tag = "placeholder";
      #     key = "placeholder";
      #   }
      # ];
    };
  };
}
