{
  den.aspects.core.preservation-user = {
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
