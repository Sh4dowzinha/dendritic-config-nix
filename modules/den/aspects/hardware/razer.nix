# modules/den/aspects/hardware/razer.nix
{
  den.aspects.hardware.razer = {
    nixos =
      {
        pkgs,
        resolved-users ? [ ],
        ...
      }:
      {
        hardware.openrazer = {
          enable = true;
          users = map (u: u.userName or u.name) resolved-users;
        };

        environment.systemPackages = [
          pkgs.polychromatic
        ];
      };

    persistHome = {
      directories = [
        ".config/openrazer"
        ".config/polychromatic"
      ];
    };
  };
}
