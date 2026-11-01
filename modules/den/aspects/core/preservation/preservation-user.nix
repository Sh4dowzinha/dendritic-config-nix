{ lib, ... }: {
  den.aspects.core.preservation-user = {
    settings = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable preservation on the host";
      };
    };

    nixos =
      {
        user,
        persistHome ? [ ],
        cacheHome ? [ ],
        lib,
        ...
      }:
      let
        mergePersist = entries: {
          commonMountOptions = lib.unique (lib.concatMap (e: e.commonMountOptions or [ ]) entries);
          directories = lib.unique (lib.concatMap (e: e.directories or [ ]) entries);
          files = lib.unique (lib.concatMap (e: e.files or [ ]) entries);
        };
      in
      {
        preservation.preserveAt."/persist".users.${user.userName} = mergePersist persistHome;
        preservation.preserveAt."/cache".users.${user.userName} = mergePersist cacheHome;
      };

    persistHome = {
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
        ".config/autostart"
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
        {
          directory = ".config/sops/age";
          mode = "0700";
        }
      ];
    };

    cacheHome = {
      commonMountOptions = [
        "x-gvfs-hide"
        "x-gdu.hide"
      ];

      directories = [
        "Downloads"
        ".cache/fontconfig"
        ".cache/nix"
        ".cache/mesa_shader_cache"
      ];
    };
  };
}
