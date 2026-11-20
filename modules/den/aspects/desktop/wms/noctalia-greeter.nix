{
  den.aspects.desktop.noctalia-greeter = {
    nixos =
      { host, ... }:
      {
        services.displayManager.noctalia-greeter = {
          enable = true;

          settings = {
            user = {
              default = host.system-owner;
            };

            keyboard = {
              layout = host.keyboard.layout or "us";
            };

            appearance = {
              scheme = "Synced";
            };
          };
        };
      };

    persist.directories = [
      {
        directory = "/var/lib/noctalia-greeter";
        user = "greeter";
        group = "greeter";
        mode = "0755";
      }
    ];
  };
}
