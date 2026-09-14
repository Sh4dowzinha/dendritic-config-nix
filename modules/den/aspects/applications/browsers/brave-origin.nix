{
  den.aspects.applications.browsers.brave-origin = {
    homeManager =
      { pkgs, ... }:
      {
        programs.brave-origin = {
          enable = true;
          nativeMessagingHosts = [
            pkgs.keepassxc
          ];

          extensions = [
            {
              id = "mnjggcdmjocbbbhaepdhchncahnbgone"; # Youtube SponsorBlock
            }
            {
              id = "gebbhagfogifgggkldgodflihgfeippi"; # Return Youtube Dislikes
            }
            {
              id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; # Dark Reader
            }
            {
              id = "oboonakemofpalcgghocfoadofidjkkk"; # KeepassXC Browser
            }
          ];
        };
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
