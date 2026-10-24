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
        avrdude
      ];
    };

    codium-settings = { pkgs, ... }: [
      {
        # Direct extension to Nix-wrapped binary
        "platformio-ide.useBuiltinPIOCore" = false;
        "platformio-ide.customPATH" = "${pkgs.platformio-core}/bin";

        # Completely mute Microsoft language server so clangd runs without conflict
        "C_Cpp.intelliSenseEngine" = "disabled";
        "C_Cpp.errorSquiggles" = "disabled";
        "C_Cpp.autocomplete" = "disabled";
        "C_Cpp.formatting" = "disabled";
        "C_Cpp.enhancedColoring" = "disabled";
      }
    ];

    codium-extensions = { pkgs, ... }: with pkgs.vscode-marketplace;
      [
        platformio.platformio-ide
        ms-vscode.cpptools
      ];

    persistHome.directories = [
      ".platformio"
    ];
  };
}
