{
  den.aspects.gpg = {
    preservation-user-class = {
      directories = [
        { directory = ".gnupg/private-keys-v1.d"; mode = "0700"; }
      ];
    };

    nixos = { user, lib, ... }: {
      systemd.tmpfiles.settings.preservation = {
        # configureParent conflicts with preservation's automatically generated
        # intermediate directory rule for .gnupg; GnuPG requires 0700.
        "/home/${user.userName}/.gnupg".d = { user = "${user.userName}"; group = "users"; mode = lib.mkForce "0700"; };
      };

      # This is needed for KeePassXC to work with hardware keys
      services.pcscd.enable = true;
    };
    
    homeManager = { pkgs, ... }: {
      programs.gpg = {
        enable = true;
        mutableKeys = false;
        mutableTrust = false;
        
        scdaemonSettings = {
          disable-ccid = true; # Needed for KeePassXC too
        };
      };
      
      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        pinentry.package = pkgs.pinentry-curses;
      };
    };
  };
}
