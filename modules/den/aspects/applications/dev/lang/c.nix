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
        # Completely mute Microsoft language server so clangd runs without conflict
        "C_Cpp.intelliSenseEngine" = "disabled";
        "C_Cpp.errorSquiggles" = "disabled";
        "C_Cpp.autocomplete" = "disabled";
        "C_Cpp.formatting" = "disabled";
        "C_Cpp.enhancedColoring" = "disabled";

        "clangd.path" = "${pkgs.clang-tools}/bin/clangd-unwrapped";
        "clangd.arguments" = [
          "--background-index"
          "--compile-commands-dir=."
          "--completion-style=detailed"
          "--header-insertion=iwyu"
          "--query-driver=${config.home.profileDirectory}/bin/g*,${config.home.homeDirectory}/.platformio/packages/**/bin/*"
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
      { pkgs, ... }:
      let
        # Patch cpptools without using curly braces in the sed replacement string
        patchedCpptools = pkgs.vscode-marketplace.ms-vscode.cpptools.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            find . -type f -name "*.js" -exec sed -i 's/fs\.chmodSync/(()=>void 0)/g' {} +
          '';
          postFixup = (old.postFixup or "") + ''
            find $out -type f -path "*/bin/*" -exec chmod +x {} + 2>/dev/null || true
          '';
        });
      in
      [
        patchedCpptools
        pkgs.vscode-marketplace.llvm-vs-code-extensions.vscode-clangd
        pkgs.vscode-marketplace.ms-vscode.cpptools-extension-pack
        pkgs.vscode-marketplace.ms-vscode.cmake-tools
        pkgs.vscode-marketplace.ms-vscode.hexeditor
        pkgs.vscode-marketplace.slevesque.shader
        pkgs.vscode-marketplace.twxs.cmake
      ];
  };
}
