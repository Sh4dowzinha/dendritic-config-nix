{ den, ... }:
{
  den.aspects.roles.messaging = {
    includes = with den.aspects; [
      applications.messaging.discord
      applications.messaging.telegram
    ];
  };
}
