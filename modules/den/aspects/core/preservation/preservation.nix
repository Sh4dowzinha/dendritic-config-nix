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
              "/var/log"
            ];

            users.sh4dow = {
              commonMountOptions = [
                "x-gvfs-hide"
                "x-gdu.hide"
              ];

              directories = [
                "Downloads"
                ".local/state/nix"
                ".local/share/Trash"
                ".cache"
              ];
            };
          };

          "/persist" = {
            commonMountOptions = [
              "x-gvfs-hide"
              "x-gdu.hide"
            ];

            directories = [
              {
                directory = "/var/lib/nixos";
                inInitrd = true;
              }
            ];

            files = [
              {
                file = "/etc/machine-id";
                inInitrd = true;
              }
            ];

            users.sh4dow = {
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
                ".local/share/direnv"
                {
                  directory = ".local/share/keyrings";
                  mode = "0700";
                }
              ];
            };
          };
        };
      };
    };
  };
}
