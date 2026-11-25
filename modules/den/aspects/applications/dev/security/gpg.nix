{ den, ... }:
{
  den.aspects.applications.dev.security.gpg = {
    nixos = {
      hardware.gpgSmartcards.enable = true;
    };

    homeManager =
      {
        config,
        host,
        pkgs,
        ...
      }:
      {
        programs.gpg = {
          enable = true;
          mutableKeys = config.programs.gpg.publicKeys == [ ];
          mutableTrust = config.programs.gpg.publicKeys == [ ];

          settings = {
            personal-cipher-preferences = "AES256 AES192 AES";
            personal-digest-preferences = "SHA512 SHA384 SHA256";
            personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
            default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
            cert-digest-algo = "SHA512";
            s2k-digest-algo = "SHA512";
            s2k-cipher-algo = "AES256";
            charset = "utf-8";
            fixed-list-mode = true;
            no-comments = true;
            no-emit-version = true;
            keyid-format = "0xlong";
            list-options = "show-uid-validity";
            verify-options = "show-uid-validity";
            with-fingerprint = true;
            require-cross-certification = true;
            no-symkey-cache = true;
            throw-keyids = true;
          };
        };

        services.gpg-agent = {
          enable = true;
          enableExtraSocket = true;
          enableSshSupport = false;

          enableBashIntegration = true;
          enableZshIntegration = true;
          enableFishIntegration = true;
          enableNushellIntegration = true;

          defaultCacheTtl = 43200;
          maxCacheTtl = 86400;

          pinentry.package =
            if (host.hasAspect den.aspects.desktop.gnome) || (host.hasAspect den.aspects.desktop.hyprland) then
              pkgs.pinentry-gnome3
            else if (host.hasAspect den.aspects.desktop.kde) then
              pkgs.pinentry-qt
            else
              pkgs.pinentry-tty;
        };
      };

    persistHome = {
      directories = [
        {
          directory = ".gnupg";
          mode = "0700";
        }
      ];
    };
  };
}
