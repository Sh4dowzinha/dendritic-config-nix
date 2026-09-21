{
  den.aspects.applications.messaging.discord = {
    homeManager = {
      programs.vesktop = {
        enable = true;
        vencord = {
          useSystem = true;
        };
      };
    };

    persistHome = {
      directories = [
        {
          directory = ".config/vesktop";
          mode = "700";
        }
      ];
    };
  };
}
