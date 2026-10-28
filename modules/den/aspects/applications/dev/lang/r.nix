let
  # R environment
  rEnv =
    pkgs:
    pkgs.rWrapper.override {
      packages = with pkgs.rPackages; [
        ggplot2
        httpgd
        languageserver
      ];
    };

  # Radian wrapper bundling python3 + radian + R environment
  radianEnv =
    pkgs:
    let
      r = rEnv pkgs;
      pythonWithRadian = pkgs.python3.withPackages (ps: [ ps.radian ]);
    in
    pkgs.writeShellScriptBin "radian" ''
      export R_HOME="${r}/lib/R"
      export PATH="${r}/bin:$PATH"
      exec "${pythonWithRadian}/bin/radian" "$@"
    '';
in
{
  den.aspects.applications.dev.lang.r = {
    homeManager = { pkgs, ... }: {
      home.packages = [
        (rEnv pkgs)
        (radianEnv pkgs)
      ];
    };

    codium-settings = { pkgs, ... }: [
      {
        # Background R executable (language server, session watcher)
        "r.executablePath" = "${(rEnv pkgs)}/bin/R";

        # Interactive terminal console
        "r.consolePath" = "${(radianEnv pkgs)}/bin/radian";

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
