{ den, ... }:
{
  den.aspects.fona = {
    includes = [ den.batteries.host-aspects ];

    homeManager = {
    };
  };

  den.users.registry.fona = {
    system.uid = 1003;

    settings = {
      #git.signing.method = "openpgp";
      github.username = "HugoFona";
    };

    identity = {
      displayName = "Hugo Fona";
      email = "hjfona@gmail.com";

      # sshKeys = [
      #   {
      #     tag = "placeholder";
      #     key = "placeholder";
      #   }
      # ];
    };
  };
}
