{
  den.aspects.applications.messaging.vesktop = {
    homeManager = _: {
      programs.vesktop = {
        enable = true;
        vencord = {
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
