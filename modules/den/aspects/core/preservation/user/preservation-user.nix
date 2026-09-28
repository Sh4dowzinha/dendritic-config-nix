{ lib, ... }: {
  den.aspects.core.preservation-user = {
    settings = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable preservation on the host";
      };
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
      ];
    };

    cacheHome = {
      commonMountOptions = [
        "x-gvfs-hide"
        "x-gdu.hide"
      ];

      directories = [
        "Downloads"
        ".local/state/nix"
        ".cache/nix"
        ".cache/mesa_shader_cache"
      ];
    };
  };
}
