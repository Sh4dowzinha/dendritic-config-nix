{ den, ... }:
{
  den.aspects.roles.messaging = {
    includes = with den.aspects; [
      applications.messaging.vesktop
      applications.messaging.telegram
      applications.messaging.zapzap
      applications.messaging.thunderbird
    ];
  };
}
