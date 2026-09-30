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

    settings = {
      #git.signing.method = "openpgp";
      github.username = "daniel0alves";
    };

    identity = {
      displayName = "Daniel Alves";
      email = "daniel.carvalho.alves.06@gmail.com";

      # sshKeys = [
      #   {
      #     tag = "placeholder";
      #     key = "placeholder";
      #   }
      # ];
    };
  };
}
