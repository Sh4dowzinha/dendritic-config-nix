let
  rPkgs =
    pkgs: with pkgs.rPackages; [
      ggplot2
      httpgd
      languageserver
    ];

  rWrapper =
    pkgs:
    pkgs.rWrapper.override {
      packages = rPkgs pkgs;
    };

  radianWrapper =
    pkgs:
    pkgs.radianWrapper.override {
      packages = rPkgs pkgs;
    };
in
{
  den.aspects.applications.dev.lang.r = {
    homeManager = { pkgs, ... }: {
      home.packages = [
        (rWrapper pkgs)
        (radianWrapper pkgs)
      ];
    };

    codium-settings = { pkgs, ... }: [
      {
        # R executable for the language server and background processes
        "r.executablePath" = "${(rWrapper pkgs)}/bin/R";

        # Radian for interactive R terminals
        "r.consolePath" = "${(radianWrapper pkgs)}/bin/radian";

        "r.bracketedPaste" = true;
        "r.sessionWatcher" = true;
        "r.plot.backend" = "httpgd";
        "r.lsp.diagnostics" = true;

        "[r]" = {
          "editor.defaultFormatter" = "REditorSupport.r";
          "editor.formatOnSave" = true;
        };
      }
    ];

    codium-extensions = { pkgs, ... }: with pkgs.vscode-marketplace;
      [
        reditorsupport.r
        reditorsupport.r-syntax
        rdebugger.r-debugger
      ];
  };
}
