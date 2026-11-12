{
  den.aspects.applications.engineering.boards = {
    nixos =
      {
        pkgs,
        lib,
        resolved-users ? [ ],
        ...
      }:
      {
        users.users = lib.genAttrs (map (u: u.userName or u.name) resolved-users) (_: {
          extraGroups = [ "dialout" ];
        });
        services.udev.packages = with pkgs; [
          platformio-core.udev
          openocd
        ];
      };

    homeManager =
      { config, pkgs, ... }:
      let
        # Standalone global script to hook compile_commands.json generation
        compiledbGenerator = pkgs.writeText "compiledb_generator.py" ''
          import sys
          Import("env")

          # 1. Include cross-compiler toolchain system headers in compile_commands.json
          env.Replace(COMPILATIONDB_INCLUDE_TOOLCHAIN=True)

          # 2. Trigger compilation database generation after building the firmware
          def update_compile_commands(source, target, env):
              # Prevent recursive loops when the compiledb target itself is executing
              if "compiledb" in [str(t) for t in COMMAND_LINE_TARGETS]:
                  return
              print("\n--- Auto-generating compile_commands.json for clangd ---")
              env.Execute(f'"{sys.executable}" -m platformio run -t compiledb')

          # Hook execution after building the firmware program binary
          env.AddPostAction("buildprog", update_compile_commands)
        '';
      in
      {
        # Expose the virtualenv binaries to all user shells, scripts, and desktop processes
        home.sessionPath = [
          "${config.home.homeDirectory}/.platformio/penv/bin"
        ];

        home.sessionVariables = {
          # Prepend the script to all PlatformIO project builds globally
          PLATFORMIO_EXTRA_SCRIPTS = "pre:${compiledbGenerator}";
        };
      };

    nix-ld-libraries =
      { pkgs, ... }:
      with pkgs;
      [
        libusb1
        ncurses5
      ];

    codium-extensions =
      { pkgs, ... }:
      with pkgs.vscode-marketplace;
      [
        platformio.platformio-ide
      ];

    persistHome.directories = [
      ".platformio"
    ];
  };
}
