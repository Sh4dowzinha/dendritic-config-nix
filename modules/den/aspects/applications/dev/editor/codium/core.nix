{
  den.aspects.applications.dev.editor.codium.core = {
    nixpkgs-overlays =
      { inputs', ... }:
      [ inputs'.nix-vscode-extensions.overlays.default ];

    homeManager =
      {
        pkgs,
        ...
      }:
      {
        home.packages = [
          pkgs.prettier
        ];
      };

    codium-settings = [
      {
        "catppuccin-icons.hidesExplorerArrows" = false;
        "catppuccin-icons.specificFolders" = true;
        "catppuccin-icons.monochrome" = false;
        "direnv.restart.automatic" = true;
        "editor.fontFamily" = "'Fira Code', monospace";
        "editor.fontLigatures" = true;
        "editor.fontWeight" = "400";
        "explorer.confirmDragAndDrop" = false;
        "extensions.autoCheckUpdates" = false;
        "extensions.ignoreRecommendations" = true;
        "[xml]"."editor.defaultFormatter" = "DotJoshJohnson.xml";
        "files.insertFinalNewline" = true;
        "files.trimTrailingWhitespace" = true;
        "git.openRepositoryInParentFolders" = "always";
        "projectManager.git" = {
          baseFolders = [
            "~/Projects"
          ];
          maxDepthRecursion = 5;
        };
        "telemetry.feedback.enabled" = false;
        "telemetry.telemetryLevel" = "off";
        "terminal.integrated.scrollback" = 10240;
        "terminal.integrated.copyOnSelection" = true;
        "terminal.integrated.cursorBlinking" = true;
        "update.mode" = "none";
        "vsicons.dontShowNewVersionMessage" = true;
        "workbench.tree.indent" = 20;
        "workbench.startupEditor" = "none";
        "workbench.editor.empty.hint" = "hidden";
      }
    ];

    codium-extensions =
      { pkgs, ... }:
      [
        pkgs.vscode-marketplace.aaron-bond.better-comments
        pkgs.vscode-marketplace.alefragnani.project-manager
        pkgs.vscode-marketplace.catppuccin.catppuccin-vsc-icons
        pkgs.vscode-marketplace.codezombiech.gitignore
        pkgs.vscode-marketplace.dotjoshjohnson.xml
        pkgs.vscode-marketplace.editorconfig.editorconfig
        pkgs.vscode-marketplace.esbenp.prettier-vscode
        pkgs.vscode-marketplace.mkhl.direnv
        pkgs.vscode-marketplace.streetsidesoftware.code-spell-checker
        pkgs.vscode-marketplace.tomoki1207.pdf
        pkgs.vscode-marketplace.vscode-icons-team.vscode-icons
      ];
  };
}
