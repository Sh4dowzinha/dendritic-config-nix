let
  # R environment with required packages
  rEnv =
    pkgs:
    pkgs.rWrapper.override {
      packages = with pkgs.rPackages; [
        ggplot2
        httpgd
        languageserver
      ];
    };

  # Radian wrapper with the full Python dependency closure and R paths
  radianEnv =
    pkgs:
    let
      r = rEnv pkgs;
      # Recursively collect dependencies of radian (rchitect, packaging, prompt-toolkit, etc.)
      pyDeps = pkgs.python3Packages.requiredPythonModules pkgs.radian.propagatedBuildInputs;
      # Build search path containing both radian itself and all its dependencies
      pythonPath = pkgs.lib.makeSearchPath pkgs.python3.sitePackages ([ pkgs.radian ] ++ pyDeps);
    in
    pkgs.writeShellScriptBin "radian" ''
      export R_HOME="${r}/lib/R"
      export PATH="${r}/bin:$PATH"
      export LD_LIBRARY_PATH="${r}/lib/R/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      export PYTHONPATH="${pythonPath}''${PYTHONPATH:+:$PYTHONPATH}"

      exec "${pkgs.radian}/bin/radian" "$@"
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
        "r.executablePath" = "${(rEnv pkgs)}/bin/R";
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
