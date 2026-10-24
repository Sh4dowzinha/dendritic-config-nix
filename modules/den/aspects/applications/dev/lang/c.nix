{
  den.aspects.applications.dev.lang.c = {
    homeManager = { pkgs, ... }: {
      programs.gcc = {
        enable = true;
        package = pkgs.gcc;
      };

      home.packages = with pkgs; [
        gnumake
        clang-tools
        valgrind
        gdb
      ];
    };

    codium-settings = { config, pkgs, ... }: [
      {
        "clangd.path" = "${pkgs.clang-tools}/bin/clangd-unwrapped";
        "clangd.arguments" = [
          "--background-index"
          "--compile-commands-dir=."
          "--completion-style=detailed"
          "--header-insertion=iwyu"
          "--query-driver=${config.home.profileDirectory}/bin/g*" # gcc and g++
          "--query-driver=${config.home.homeDirectory}/.platformio/packages/**/bin/*" # platformio
        ];

        "[c]" = {
          "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
          "editor.formatOnSave" = true;
        };

        "[cpp]" = {
          "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
          "editor.formatOnSave" = true;
        };
      }
    ];

    codium-extensions = { pkgs, ... }: with pkgs.vscode-marketplace;
      [
        llvm-vs-code-extensions.vscode-clangd
        ms-vscode.cmake-tools
        ms-vscode.hexeditor
        slevesque.shader
        twxs.cmake
      ];
  };
}
