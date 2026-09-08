{
  den.aspects.desktop.xserver = {
    nixos = { host, ... }: {
      services = {
        libinput.enable = true;
        xserver = {
          enable = true;
          xkb = {
            layout = host.keyboard.layout or "us";
            variant = "";
          };
        };
      };
    };
  };
}
