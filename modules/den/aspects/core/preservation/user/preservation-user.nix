{ den, ... }:
{
  den.aspects.core.preservation.user = {
    policies.require-host-preservation =
      { host, user, ... }:
      if host.hasAspect den.aspects.core.preservation then
        [ ]
      else
        throw ''
          Preservation user aspect used for '${user.userName}', but
          host '${host.name}' does not include
          den.aspects.core.preservation.
        '';

    includes = [
      den.aspects.core.preservation.user-emitter
    ];

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
