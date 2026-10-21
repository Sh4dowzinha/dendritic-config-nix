{ inputs, ... }:
{
  flake-file.inputs = {
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { config, pkgs, ... }:
    # Temporary ix for toml-sort incompatiblilty until
    # version 0.25.0 isn't available on nixpkgs
    let
      compatibleTomlSort = pkgs.toml-sort.override {
        python3Packages = pkgs.python3Packages.overrideScope (
          pyFinal: pyPrev: {
            tomlkit = pyPrev.tomlkit.overridePythonAttrs (old: rec {
              version = "0.15.0";

              src = pkgs.fetchPypi {
                pname = "tomlkit";
                inherit version;
                hash = "sha256-fRqey6MIZjghGxOBTqeckN1U3RGZNWQ3bzqpInH1x6M=";
              };
            });
          }
        );
      };

    in
    {
      # Provide a formatter package for `nix fmt`. Setting this
      # to `config.treefmt.build.wrapper` will use the treefmt
      # package wrapped with my desired configuration.
      formatter = config.treefmt.build.wrapper;

      treefmt = {
        # inherit (config.flake-root) projectRootFile;
        projectRootFile = ".git/config";

        enableDefaultExcludes = true;

        settings = {
          # on-unmatched = "fatal";
          on-unmatched = "warn";

          global.excludes = [
            "generated/**"
            "secrets/**"
            "*.editorconfig"
            "*.envrc"
            "*.gitconfig"
            "*.gitignore"
            "*CODEOWNERS"
            "*LICENSE"
            "*flake.lock"
            "*.svg"
            "*.png"
            "*.gif"
            "*.ico"
            "*.jpg"
            "*.webp"
            "*.conf"
            "*.age"
            "*.pub"
            "*.asc"
            "*.org"
            "*.zsh"
            "*.fish"
            "*.kdl"
            "*.txt"
            "*.tmpl"
            "*.jwe"
            "*.xml"
            "*.dds"
            "*.diff"
            "*.patch"
            "*.bin"
            # Underscore-prefixed files/dirs are ignored by the module auto-import system
            "**/_*/**"
            "**/_*"
          ]
          # Exclude generated files from the files.files flake-parts module
          ++ config.files.paths;

          mdformat.options = [ "--number" ];
          shellcheck.options = [
            "--shell=bash"
            "--check-sourced"
          ];
          yamlfmt.options = [
            "-formatter"
            "retain_line_breaks=true"
          ];
          formatter = {
            ruff-check.priority = 1;
            ruff-format.priority = 2;
            # mdformat.options = [
            #   "--wrap"
            #   "keep"
            # ];
            prettier = {
              options = [
                "--tab-width"
                "2"
              ];
              # includes = [ "*.{css,html,js,json,jsx,scss,ts,yml,yaml}" ];
            };
          };
        };

        programs = {
          actionlint.enable = true;
          fish_indent.enable = true;
          isort.enable = true;
          nixfmt = {
            enable = true;
            package = pkgs.nixfmt;
            includes = [ "**/*.nix" ];
          };
          nixf-diagnose = {
            enable = true;
            ignore = [
              "sema-unused-def-lambda-witharg-formal"
              "sema-unused-def-lambda-noarg-formal"
              "sema-primop-overridden"
              "sema-unused-def-let"
            ];
          };
          prettier = {
            enable = true;
            settings = {
              arrowParens = "always";
              bracketSameLine = false;
              bracketSpacing = true;
              editorconfig = true;
              embeddedLanguageFormatting = "auto";
              endOfLine = "lf";
              # experimentalTernaries = false;
              htmlWhitespaceSensitivity = "css";
              insertPragma = false;
              jsxSingleQuote = true;
              printWidth = 80;
              proseWrap = "always";
              quoteProps = "consistent";
              requirePragma = false;
              semi = true;
              singleAttributePerLine = true;
              singleQuote = false;
              trailingComma = "all";
              useTabs = false;
              vueIndentScriptAndStyle = false;

              tabWidth = 2;
            };
          };

          # Python formatting
          ruff = {
            check = true;
            format = true;
          };

          taplo.enable = true;

          yamlfmt = {
            enable = true;
          };

          toml-sort.enable = true;
          toml-sort.package = compatibleTomlSort;

          # mdformat.enable = true;

          shellcheck.enable = true;

        };
      };
    };
}
