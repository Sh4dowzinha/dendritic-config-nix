{ den, ... }:
{
  den.aspects.roles.gaming = {
    includes = with den.aspects; [
      applications.gaming.nix-ld
      applications.gaming.steam
      applications.gaming.mangohud
      applications.gaming.umu-launcher
    ];
  };
}
