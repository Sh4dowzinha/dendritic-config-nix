{
  den.aspects.applications.browsers.librewolf = {
    homeManager = _: {
      programs.librewolf = {
        enable = true;

        profiles.default = {
          id = 0;
          name = "default";
          path = "default";
          isDefault = true;

          settings = {
            "browser.download.useDownloadDir" = false;
          };
        };
      };
    };

    persistHome.directories = [
      ".librewolf/default"
    ];
  };
}
