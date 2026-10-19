{
  den.aspects.applications.dev.lang.r = {
    homeManager =
      { pkgs, ... }:
      let
        rPkgs = with pkgs.rPackages; [
          ggplot2
          httpgd
          languageserver
        ];

        R-base = pkgs.rWrapper.override { packages = rPkgs; };
        Radian-base = pkgs.radianWrapper.override { packages = rPkgs; };
      in
      {
        home.packages = [
          R-base
          Radian-base
        ];
      };

    codium-settings = { pkgs, ... }: [
      {
        "r.rpath.linux" = "${pkgs.rWrapper}/bin/R";
        "r.rterm.linux" = "${pkgs.radianWrapper}/bin/radian";
        "r.bracketedPaste" = true;
        "r.sessionWatcher" = true;
        "r.plot.useHttpgd" = true;
        "r.lsp.diagnostics" = true;
        "[r]" = {
          "editor.defaultFormatter" = "REditorSupport.r";
          "editor.formatOnSave" = true;
        };
      }
    ];

    codium-extensions =
      { pkgs, ... }:
      [
        pkgs.vscode-marketplace.reditorsupport.r
      ];
  };
}
