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

    homeManager =
      { config, pkgs, ... }:
      {
        home.packages = with pkgs; [
          avrdude
        ];

        # Expose the virtualenv binaries to all user shells, scripts, and desktop processes
        home.sessionPath = [
          "${config.home.homeDirectory}/.platformio/penv/bin"
        ];
      };

    nix-ld-libraries = { pkgs, ... }: with pkgs;
      [
        libusb1
        ncurses5
      ];

    codium-extensions = { pkgs, ... }: with pkgs.vscode-marketplace;
      [
        platformio.platformio-ide
      ];

    persistHome.directories = [
      ".platformio"
    ];
  };
}
