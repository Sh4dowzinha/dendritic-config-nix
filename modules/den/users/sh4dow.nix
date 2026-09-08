{ den, ... }:
{
  den.aspects.sh4dow = {
    includes = [ den.batteries.host-aspects ];
  };

  den.users.registry.sh4dow = {
    system.uid = 1000;
    groups = [
      "admins"
    ];
    settings.git.signing.method = "openpgp";

    identity = {
      displayName = "André Fernandes";
      email = "andrematosf727@gmail.com";

      sshKeys = [
        {
          tag = "nitrokey";
          key = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDCNnq6T9Rg20AlgPfu/N5uETTIKu/cHFr4Vv8U1DCt4AAAABHNzaDo= ssh:";
        }
      ];
    };
  };
}
