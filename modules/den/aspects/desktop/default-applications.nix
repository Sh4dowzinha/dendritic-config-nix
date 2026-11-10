{
  den,
  lib,
  rootPath,
  ...
}:
let
  defaultApps = import (rootPath + "/modules/den/lib/_default-applications.nix") { inherit den lib; };
in
{
  den.aspects.desktop.default-applications = {
    # Dynamically generated schema options from catalog categories
    settings = defaultApps.options;

    homeManager =
      {
        host,
        user,
        lib,
        ...
      }:
      let
        defaults = defaultApps.resolveEffectiveDefaults { inherit host user; };

        browser = defaultApps.resolveDesktopId "browser" (defaults.browser or null);
        #terminal = defaultApps.resolveDesktopId "terminal" (defaults.terminal or null);
      in
      {
        xdg.mimeApps = {
          enable = true;
          defaultApplications = lib.pipe defaultApps.mimeTypes [
            (lib.mapAttrsToList (
              category: mimes:
              let
                handler = defaultApps.resolveDesktopId category (defaults.${category} or null);
              in
              lib.optionalAttrs (handler != null) (lib.genAttrs mimes (_: handler))
            ))
            lib.mkMerge
          ];
        };
      }
      // lib.optionalAttrs (host.hasAspect den.aspects.desktop.plasma-manager) {
        programs.plasma.configFile.kdeglobals = {
          General = lib.mkMerge [
            (lib.optionalAttrs (browser != null) {
              BrowserApplication = browser;
            })
            #(lib.optionalAttrs (terminal != null) {
            #  TerminalApplication = terminal;
            #  TerminalService = terminal;
            #})
          ];
        };
      };
  };
}
