{
  den.aspects.applications.browsers.brave-origin = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.brave-origin
        ];
      };

    homeLinux = {
      xdg.mimeApps.defaultApplications = {
        "text/html" = [ "brave-origin.desktop" ];
        "text/xml" = [ "brave-origin.desktop" ];
        "x-scheme-handler/http" = [ "brave-origin.desktop" ];
        "x-scheme-handler/https" = [ "brave-origin.desktop" ];
      };
    };

    persistHome.directories = [
      ".config/BraveSoftware/Brave-Origin"
    ];
  };
}
