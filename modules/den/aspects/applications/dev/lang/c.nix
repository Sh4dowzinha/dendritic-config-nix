{
  den.aspects.applications.dev.lang.c = {
    homeManager = { pkgs, ... }: {
      programs.gcc = {
        enable = true;
        package = pkgs.gcc;
      };
    };

    codium-extensions = { pkgs, ... }: [
      pkgs.vscode-marketplace.ms-vscode.cmake-tools
      pkgs.vscode-marketplace.ms-vscode.hexeditor
      pkgs.vscode-marketplace.ms-vscode.cpptools-extension-pack
    ];
  };
}
