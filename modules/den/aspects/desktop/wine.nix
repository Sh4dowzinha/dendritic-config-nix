{
  den.aspects.desktop.wine = {
    nixpkgs-overlays = { ... }: [
      (_final: prev: {
        winetricks = prev.winetricks.overrideAttrs (old: {
          postInstall = (old.postInstall or "") + ''
            wrapProgram "$out/bin/winetricks" \
              --run '
                if [ -z "''${WINE_BIN:-}" ]; then
                  wine_cmd="''${WINE:-$(command -v wine || true)}"
                  if [ -n "$wine_cmd" ]; then
                    wine_path="$(readlink -f "$wine_cmd")"
                    wine_bin="$(dirname "$wine_path")/.wine"
                    if [ -x "$wine_bin" ]; then
                      export WINE_BIN="$wine_bin"
                    fi
                  fi
                fi

                if [ -z "''${WINESERVER_BIN:-}" ]; then
                  wineserver_cmd="''${WINESERVER:-$(command -v wineserver || true)}"
                  if [ -n "$wineserver_cmd" ]; then
                    export WINESERVER_BIN="$(readlink -f "$wineserver_cmd")"
                  fi
                fi
              '
          '';
        });
      })
    ];

    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        winetricks
        wineWow64Packages.full
      ];
    };
  };
}
