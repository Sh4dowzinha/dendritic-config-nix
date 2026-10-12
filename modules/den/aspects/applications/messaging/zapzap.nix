{
  den.aspects.applications.messaging.zapzap = {
    homeManager = {
      programs.zapzap = {
        enable = true;
        settings = {
          notification = {
            donation_message = false;
          };
          onboarding = {
            initial_setup_completed = true;
          };
          website = {
            open_page = false;
          };
        };
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
