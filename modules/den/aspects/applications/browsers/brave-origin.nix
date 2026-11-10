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
            {
              id = "npapjbliocdhineglcjkmmmaddpgeono"; # Google drive preview exporter
            }
          ];
        };
      };

    persistHome.directories = [
      ".config/BraveSoftware/Brave-Origin"
    ];

    cacheHome.directories = [
      ".cache/BraveSoftware/Brave-Origin"
    ];
  };
}
