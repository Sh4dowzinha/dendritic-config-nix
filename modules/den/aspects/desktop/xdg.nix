{
  den.aspects.desktop.xdg = {
    nixos = { pkgs, ... }: {
      xdg = {
        portal = {
          enable = true;
          xdgOpenUsePortal = true;
          config = {
            common = {
              default = [ "gtk" ];
            };
          };
          extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
          ];
        };

        terminal-exec = {
          enable = true;
          settings = {
            default = [
              "kitty.desktop"
            ];
          };
        };
      };
    };

    homeManager =
      {
        lib,
        pkgs,
        autostart ? [ ],
        ...
      }:
      let
        # Resolves functions { pkgs, ... }: [ ... ] or static lists [ ... ]
        resolveQuirkItem = x: if lib.isFunction x then x { inherit pkgs; } else x;
        rawEntries = lib.flatten (map resolveQuirkItem autostart);

        # Resolves packages to standard share/applications paths or passes string paths through
        resolvePath =
          entry:
          if lib.isDerivation entry then
            let
              pname = entry.pname or entry.name;
            in
            "${entry}/share/applications/${pname}.desktop"
          else
            toString entry;
      in
      {
        xdg = {
          enable = true;
          userDirs = {
            enable = true;
            createDirectories = true;
          };

          autostart = {
            enable = true;
            entries = lib.unique (map resolvePath rawEntries);
          };
        };
      };
  };
}
