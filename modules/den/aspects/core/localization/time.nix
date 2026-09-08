# time — timezone from environment entity.
#
# Ported from main:modules/_legacy/core/time.nix.
{
  den.aspects.core.localization.time = {
    os =
      { host, ... }:
      {
        time.timeZone = host.timezone or "UTC";
      };
  };
}
