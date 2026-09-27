{ den, ... }:
{
  den.aspects.fona = {
    includes = [ den.batteries.host-aspects ];
  };

  den.users.registry.fona = {
    system.uid = 1000;
    groups = [
      "admins"
    ];

    identity = {
      displayName = "Hugo Fona";
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
