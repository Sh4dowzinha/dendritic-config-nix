{
  den.aspects.hardware.razer = {
    nixos =
      {
        pkgs,
        resolved-users,
        ...
      }:
      {
        services.razer-laptop-control.enable = true;

        hardware.openrazer.enable = true;
        hardware.openrazer.users = map (u: u.name) resolved-users;
        environment.systemPackages = [
          pkgs.openrazer-daemon
          pkgs.polychromatic
        ];
      };

    persistHome = {
      directories = [
        ".config/openrazer/"
        ".config/polychromatic/"
        ".local/share/razercontrol"
      ];
    };
  };
}
