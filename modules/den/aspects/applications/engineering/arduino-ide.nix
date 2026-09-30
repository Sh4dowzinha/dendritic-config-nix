{
  den.aspects.applications.engineering.arduino-ide = {
    nixos =
      { user, ... }:
      let
        inherit (user) userName;
      in
      {
        users.users.${userName}.extraGroups = [ "dialout" ];
      };

    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        arduino-ide
      ];
    };
  };
}
