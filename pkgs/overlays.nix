{ inputs, ... }:
{
  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays

  modifications = final: prev: {

    # Modified version of from rumboon's dolphin-overlay
    # https://github.com/rumboon/dolphin-overlay
    kdePackages = prev.kdePackages.overrideScope (
      kfinal: kprev: {
        dolphin = prev.symlinkJoin {
          name = "dolphin-wrapped";
          paths = [
            kprev.dolphin
            kprev.dolphin.dev
          ];
          nativeBuildInputs = [ prev.makeWrapper ];
          postBuild = ''
            rm $out/bin/dolphin
            makeWrapper ${kprev.dolphin}/bin/dolphin $out/bin/dolphin \
              --set XDG_CONFIG_DIRS "${kprev.plasma-workspace}/etc/xdg:$XDG_CONFIG_DIRS" \
              --run "${kprev.plasma-workspace}/bin/kbuildsycoca6 --noincremental ${kprev.plasma-workspace}/etc/xdg/menus/applications.menu"
          '';
          passthru = (kprev.dolphin.passthru or { }) // {
            dev = kprev.dolphin.dev;
          };
        };
      }
    );

    # Fix winetricks not opening
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
          ';
      '';
    });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
  };
}
