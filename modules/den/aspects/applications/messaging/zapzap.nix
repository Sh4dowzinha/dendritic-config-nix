{
  den.aspects.applications.messaging.zapzap = {
    homeManager = {
      programs.zapzap = {
        enable = true;
      };
    };

    persistHome.directories = [
      {
        directory = ".local/share/ZapZap";
        mode = "0700";
      }
    ];
  };
}
