{
  den.aspects.applications.dev.lang.nix = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        nixd
        nixfmt
      ];

      programs.nix-your-shell.enable = true;
    };

    codium-settings = [
      {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
          };
        };

        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = true;
          "editor.tabSize" = 2;
        };
      }
    ];

    codium-extensions = { pkgs, ... }: [
      pkgs.vscode-marketplace.jnoortheen.nix-ide
      pkgs.vscode-marketplace.pinage404.nix-extension-pack
    ];
  };
}
