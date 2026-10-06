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
      ];
    };

    codium-settings = { config, pkgs, ... }: [
      {
        "clangd.path" = "${pkgs.clang-tools}/bin/clangd-unwrapped";
        "clangd.arguments" = [
          "--query-driver=${config.home.profileDirectory}/bin/g++"
          "--query-driver=${config.home.profileDirectory}/bin/gcc"
          #"--format-style=llvm"
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

    codium-extensions =
      { pkgs, lib, ... }:
      let
        inherit (pkgs.stdenv.hostPlatform) isLinux;
      in
      [
        pkgs.vscode-marketplace.llvm-vs-code-extensions.vscode-clangd
        pkgs.vscode-marketplace.ms-vscode.cmake-tools
        pkgs.vscode-marketplace.ms-vscode.hexeditor
        pkgs.vscode-marketplace.slevesque.shader
        pkgs.vscode-marketplace.twxs.cmake
      ]
      ++ lib.optionals isLinux [
        pkgs.vscode-extensions.vadimcn.vscode-lldb
      ];
  };
}
