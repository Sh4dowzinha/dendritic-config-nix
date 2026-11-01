{
  den,
  lib,
  inputs,
  ...
}:
{
  flake-file.inputs = {
    preservation.url = "github:nix-community/preservation";
  };

  den.aspects.core.preservation = {
    includes = [
      den.aspects.core.preservation.tmpfs
    ];

    settings = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable preservation on the host";
      };
    };

    nixos =
      {
        host,
        persist ? [ ],
        cache ? [ ],
        lib,
        ...
      }:
      let
        mergePersist = entries: {
          directories = lib.unique (lib.concatMap (e: e.directories or [ ]) entries);
          files = lib.unique (lib.concatMap (e: e.files or [ ]) entries);
        };
      in
      {
        imports = [
          inputs.preservation.nixosModules.preservation
        ];

        config = lib.mkIf (host.settings.core.preservation.enable or false) {
          systemd.suppressedSystemUnits = [
            "systemd-machine-id-commit.service"
          ];

          preservation.enable = true;

          preservation.preserveAt = {
            "/cache" = lib.mkMerge [
              (mergePersist cache)
              {
                persistentStoragePath = "/cache";
                commonMountOptions = [
                  "x-gvfs-hide"
                  "x-gdu.hide"
                ];
                directories = [
                  "/var/log"
                ];
              }
            ];

            "/persist" = lib.mkMerge [
              (mergePersist persist)
              {
                commonMountOptions = [
                  "x-gvfs-hide"
                  "x-gdu.hide"
                ];
                files = [
                  {
                    file = "/etc/machine-id";
                    inInitrd = true;
                  }
                ];
              }
            ];
          };
        };
      };
  };
}
