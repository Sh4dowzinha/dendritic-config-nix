{
  den.aspects.desktop.wayland = {
    nixos =
      { pkgs, ... }:
      {
        environment = {
          systemPackages = with pkgs; [
            wl-clipboard
            wayland-utils
          ];

          sessionVariables = {
            NIXOS_OZONE_WL = "1";
          };
        };
      };
  };
}
