{
  den.aspects.applications.messaging.telegram = {
    nixos = {
      nix.settings = {
        substituters = [ "https://ayugram-desktop.cachix.org" ];
        trusted-public-keys = [ "ayugram-desktop.cachix.org-1:AZ5EqHrJsAKL5YkZYLPEsb1FdD9QlypUwQ0REcJftgA=" ];
      };
    };
    
#    homeManager =
#      { inputs', ... }:
#      {
#        home.packages = [
#          inputs'.ayugram-desktop.packages.ayugram-desktop
#        ];
#      };
  };
}
