{
  den.aspects.applications.messaging.discord = {
    homeManagerModules = { inputs', ... }: [
      inputs'.nixcord.homeModules.nixcord
    ];

    homeManager = {
      programs.nixcord = {
        enable = true;
        discord.vencord.enable = true;

        config = {
          plugins = {
            fakeNitro.enable = true;
            noTypingAnimation.enable = true;
          };
        };
      };
    };
  };
}
