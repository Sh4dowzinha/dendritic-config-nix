{ inputs, ... }:
{
  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {

    # Temporary GCC 16 / C++20 compatibility fix.
    # Based on Gentoo's rxvt-unicode-9.31-cxx20.patch:
    # https://gitweb.gentoo.org/repo/gentoo.git/tree/x11-terms/rxvt-unicode/files/rxvt-unicode-9.31-cxx20.patch
    rxvt-unicode-unwrapped = prev.rxvt-unicode-unwrapped.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        ./rxvt-unicode-9.31-cxx20.patch
      ];
    });

    contour = prev.contour.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        ./contour-0.6.3-gcc16-simd.patch
      ];
    });

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
