{
  den.aspects.applications.dev.lang.c = {
    homeManager = { pkgs, ... }: {
      programs.gcc = {
        enable = true;
        package = pkgs.gcc;
      };
    };

    codium-extensions =
      { pkgs, lib, ... }:
      let
        inherit (pkgs.stdenv.hostPlatform) isLinux;
      in
      [
        pkgs.vscode-marketplace.ms-vscode.cmake-tools
        pkgs.vscode-marketplace.ms-vscode.hexeditor
        pkgs.vscode-marketplace.slevesque.shader
        pkgs.vscode-marketplace.twxs.cmake
        pkgs.vscode-marketplace.ms-vscode.cpptools-extension-pack
      ]
      ++ lib.optionals isLinux [
        pkgs.vscode-extensions.ms-vscode.cpptools-extension-pack
        pkgs.vscode-extensions.vadimcn.vscode-lldb
      ];
  };
}
