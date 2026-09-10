{
  den.aspects.applications.messaging.telegram = {
    nixos = {
      nix.settings = {
        substituters = [ "https://ayugram-desktop.cachix.org" ];
        trusted-public-keys = [
          "ayugram-desktop.cachix.org-1:AZ5EqHrJsAKL5YkZYLPEsb1FdD9QlypUwQ0REcJftgA="
        ];
        extra-substituters = [ "https://tg-owt.cachix.org" ];
        extra-trusted-public-keys = [ "tg-owt.cachix.org-1:lp0BukIhSK3EIyLcDhDZ5zABgT48nmNp6t4SnZ0wr8w=" ];
      };
    };

    homeManager =
      { inputs', ... }:
      {
        home.packages = [
          inputs'.ayugram-desktop.packages.ayugram-desktop
        ];
      };
  };
}
