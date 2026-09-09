{
  den,
  lib,
  inputs,
  ...
}:
{
  den.aspects.core.preservation = {
    includes = [
      den.aspects.core.preservation.persist-collector
      den.aspects.core.preservation.persist-home-collector
      den.aspects.core.preservation.tmpfs
    ];

    settings = {
      wipeRootOnBoot = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Roll the root filesystem back to a pristine state on boot";
      };
      wipeHomeOnBoot = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Roll the home filesystem back to a pristine state on boot";
      };
    };

    nixos = { host, ... }: {
      imports = [
        inputs.preservation.nixosModules.preservation
      ];

      config = lib.mkIf (host.settings.core.preservation.wipeRootOnBoot or false) {
        preservation.enable = true;
        preservation.preserveAt = {
          "/cache" = {
            persistentStoragePath = "/cache";
            commonMountOptions = [
              "x-gvfs-hide"
              "x-gdu.hide"
            ];

            directories = [
              { directory = "/var/lib/nixos"; inInitrd = true; }
              "/var/tmp"
              "/var/log"
            ];
            
            users = lib.mapAttrs (userName: _: lib.mkIf (host.settings.core.preservation.wipeHomeOnBoot or false) {
              commonMountOptions = [
                "x-gvfs-hide"
                "x-gdu.hide"
              ];

              directories = [
                "Downloads"
                ".local/share/direnv"
                ".local/state/nix"
                ".cache"
              ];
            }) host.users;
          };

          "/persist" = {
            commonMountOptions = [
              "x-gvfs-hide"
              "x-gdu.hide"
            ];

            directories = [ ];

            files = [
              { file = "/etc/machine-id"; inInitrd = true; }
              "/etc/adjtime"
            ];

            users = lib.mapAttrs (userName: _: lib.mkIf (host.settings.core.preservation.wipeHomeOnBoot or false) {
              commonMountOptions = [
                "x-gvfs-hide"
                "x-gdu.hide"
              ];

              directories = [
                "Desktop"
                "Documents"
                "Music"
                "Pictures"
                "Projects"
                "Public"
                "Templates"
                "Videos"
                {
                  directory = ".ssh";
                  mode = "0700";
                }
                {
                  directory = ".local/share/keyrings";
                  mode = "0700";
                }
              ];
            }) host.users;
          };
        };
      };
    };
  };
}
