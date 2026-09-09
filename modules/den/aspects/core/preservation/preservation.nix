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
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable preservation on the host";
      };
    };

    nixos = { host, ... }: {
      imports = [
        inputs.preservation.nixosModules.preservation
      ];

      config = lib.mkIf (host.settings.core.preservation.enable or false) {
        preservation.enable = true;
        preservation.preserveAt = {
          "/cache" = {
            persistentStoragePath = "/cache";
            commonMountOptions = [
              "x-gvfs-hide"
              "x-gdu.hide"
            ];

            directories = [
              {
                directory = "/var/lib/nixos";
                inInitrd = true;
              }
              "/var/log"
            ];

            users = lib.mapAttrs (userName: _: {
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
              {
                file = "/etc/machine-id";
                inInitrd = true;
              }
            ];

            users = lib.mapAttrs (userName: _: {
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
