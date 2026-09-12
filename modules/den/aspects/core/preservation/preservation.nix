{
  den,
  lib,
  inputs,
  ...
}:
{
  den.aspects.core.preservation = {
    includes = [
      den.aspects.core.preservation.collector
      den.aspects.core.preservation.user-collector
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
        systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

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
          };
        };
      };
    };
  };
}
