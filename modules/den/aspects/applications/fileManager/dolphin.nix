{
  den.aspects.applications.fileManager.dolphin = {
    nixpkgs-overlays = { ... }: [
      (_final: prev: {
        kdePackages = prev.kdePackages.overrideScope (
          _kfinal: kprev: {
            dolphin = prev.symlinkJoin {
              name = "${kprev.dolphin.name}-wrapped";
              paths = [
                kprev.dolphin
                kprev.dolphin.dev
              ];
              nativeBuildInputs = [ prev.makeWrapper ];
              postBuild = ''
                rm "$out/bin/dolphin"
                makeWrapper "${kprev.dolphin}/bin/dolphin" "$out/bin/dolphin" \
                  --prefix XDG_CONFIG_DIRS : "${kprev.plasma-workspace}/etc/xdg" \
                  --run "${kprev.kservice}/bin/kbuildsycoca6 --noincremental ${kprev.plasma-workspace}/etc/xdg/menus/applications.menu"
              '';
              passthru = (kprev.dolphin.passthru or { }) // {
                inherit (kprev.dolphin) dev;
              };
            };
          }
        );
      })
    ];

    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs.kdePackages; [
        filelight
        dolphin
        dolphin-plugins
        kio
        kio-admin
        kio-extras
        kio-fuse
        kio-zeroconf
      ];
    };
  };
}
