{
  den.aspects.applications.engineering.boards = {
    nixos =
      { user, pkgs, ... }:
      let
        inherit (user) userName;
      in
      {
        users.users.${userName}.extraGroups = [ "dialout" ];
        services.udev.packages = with pkgs; [
          platformio-core.udev
          openocd
        ];
      };

    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        platformio-core
      ];
    };

    codium-settings = [
      # vscode declarative config goes here to get merged with
      # other aspects
    ];

    codium-extensions = { pkgs, ... }: with pkgs.vscode-marketplace;
      [
        platformio.platformio-ide
      ];
  };
}
