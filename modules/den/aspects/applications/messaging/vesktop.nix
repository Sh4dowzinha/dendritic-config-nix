{
  den.aspects.applications.messaging.vesktop = {
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
          mode = "0700";
        }
      ];
    };
  };
}
