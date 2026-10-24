{
  den.aspects.applications.messaging.telegram = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        telegram-desktop
      ];
    };

    #persistHome.directories = [
    #  {
    #    directory = ".local/share/AyuGramDesktop";
    #    mode = "0700";
    #  }
    #];
  };
}
