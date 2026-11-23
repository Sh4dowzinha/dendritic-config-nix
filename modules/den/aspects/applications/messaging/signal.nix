{
  den.aspects.applications.messaging.signal = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        signal-desktop
      ];
    };
    persistHome.directories = [
      {
        directory = ".config/Signal";
        mode = "0700";
      }
    ];
  };
}
