{ den, ... }:
{
  den.aspects.roles.music-production = {
    includes = with den.aspects.roles.creative; [
      daw
      chiptune
    ];
  };
}
