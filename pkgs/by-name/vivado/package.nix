{
  lib,
  stdenvNoCC,

  requireFile,
  buildFHSEnv,
  makeDesktopItem,
  writeShellScript,

  # Installer utilities
  bash,
  coreutils,
  findutils,
  gawk,
  gnugrep,
  gnused,
  getconf,
  lsb-release,

  # Vivado runtime
  alsa-lib,
  at-spi2-atk,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  glib,
  gsettings-desktop-schemas,
  graphviz,
  gtk2,
  gtk3,
  hicolor-icon-theme,
  libdrm,
  libGL,
  libgcrypt,
  libpng,
  libsecret,
  libusb1,
  libuuid,
  libx11,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxinerama,
  libxkbcommon,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxtst,
  ncurses5,
  nettools,
  openssl,
  pango,
  stdenv,
  unzip,
  which,
  xdg-utils,
  zlib,
}:

let
  version = "2026.1";
  release = "0616_1700";

  sfdName = "FPGAs_AdaptiveSoCs_Unified_SDI_${version}_${release}.tar";

  sfd = requireFile {
    name = sfdName;

    hash = "sha256-gYBzQGgTbeRSDVfMiU40vluybKMRyp4QtlNM/7wI8Fk=";

    url =
      "https://www.amd.com/en/support/downloads/adaptive-socs-and-fpgas/"
      + "development-tools/2026-1.html";

    message = ''
      AMD Vivado ${version} is proprietary software and requires manual
      download from AMD.

      Download:

        ${sfdName}

      Then add the file to the Nix store:

        nix-store --add-fixed sha256 /path/to/${sfdName}
    '';
  };

  /*
    AMD's installer assumes an FHS Linux installation.

    It also creates its own temporary directory under /tmp:

      /tmp/TMP_LD_LIB_PATH...

    We patch that path during unpacking so the temporary installer data
    stays inside the Nix build directory instead of your system /tmp
    tmpfs.
  */

  installerScript = writeShellScript "vivado-installer" ''
    set -euo pipefail

    sourceRoot="$1"
    installRoot="$2"
    config="$3"

    # Keep AMD's writable state and temporary files on the disk-backed
    # Nix build filesystem.
    export HOME="$sourceRoot/.vivado-home"
    export TMPDIR="$sourceRoot/.vivado-tmp"

    mkdir -p "$HOME"
    mkdir -p "$TMPDIR"
    mkdir -p "$installRoot"

    cd "$sourceRoot"

    exec ./xsetup \
      --agree XilinxEULA,3rdPartyEULA \
      --batch Install \
      --config "$config"
  '';

  /*
    FHS environment used only while AMD's installer is running.

    The installer supplies its own:
      - JRE
      - Java libraries
      - Boost
      - libstdc++
      - ncurses/tinfo variants
      - other native installer libraries

    We therefore only provide the host-side libraries/utilities that
    its bundled JRE and shell scripts expect.
  */
  installerFHS = buildFHSEnv {
    name = "vivado-installer";

    targetPkgs =
      pkgs: with pkgs; [
        bash
        coreutils
        findutils
        gawk
        gnugrep
        gnused
        getconf
        lsb-release

        glib
        gtk2
        gtk3

        libx11
        libxext
        libxi
        libxrender
        libxtst
        libxcb

        fontconfig
        freetype
        zlib
      ];

    runScript = installerScript;
  };

  vivadoUnwrapped = stdenvNoCC.mkDerivation {
    pname = "vivado-unwrapped";
    inherit version;

    src = sfd;

    nativeBuildInputs = [
      bash
      coreutils
      findutils
      gawk
      gnugrep
      gnused
      getconf
      lsb-release
    ];

    dontConfigure = true;
    dontBuild = true;
    dontCheckForBrokenSymlinks = true;

    sourceRoot = "FPGAs_AdaptiveSoCs_Unified_SDI_${version}_${release}";

    postUnpack = ''
      #  AMD uses /bin/bash in all of its shell scripts, while NixOS
      #  deliberately doesn't provide a traditional /bin/bash.

      patchShebangs "$sourceRoot"


      #  xsetup contains one hard-coded /bin/rm rather than relying on
      #  PATH, so patch that explicitly.

      substituteInPlace "$sourceRoot/xsetup" \
        --replace-fail \
          '/bin/rm' \
          '${coreutils}/bin/rm'


      #  AMD's setup-boot-loader.sh hard-codes its temporary native-library
      #  directory below /tmp. Put it below the Nix build directory instead.
      #
      #  xsetup is invoked with the source tree as $PWD.

      substituteInPlace "$sourceRoot/bin/setup-boot-loader.sh" \
        --replace-fail \
          '/tmp/TMP_LD_LIB_PATH' \
          '$PWD/.vivado-tmp/TMP_LD_LIB_PATH'
    '';

    installPhase = ''
      runHook preInstall

      cp ${./install_config.txt} install-config.txt

      installRoot="$PWD/vivado-install"

      substituteInPlace install-config.txt \
        --replace-fail \
          'Destination=' \
          "Destination=$installRoot"

      rm -rf "$installRoot"
      mkdir -p "$installRoot"

      #  Run xsetup inside the FHS environment, but have it write to the
      #  writable Nix build directory rather than /nix/store.

      ${installerFHS}/bin/vivado-installer \
        "$PWD" \
        "$installRoot" \
        "$PWD/install-config.txt"

      # AMD's installer generates settings files containing the temporary
      # installation path. Relocate those paths into the final Nix output.
      installedRoot="$out/2026.1"

      #  AMD has finished installing. Now copy the resulting tree into
      #  the immutable Nix output.

      mkdir -p "$out"
      cp -a "$installRoot/." "$out/"

      substituteInPlace \
        "$out/2026.1/Vivado/.settings64-Vivado.sh" \
        "$out/2026.1/Vivado/.settings64-Vivado.csh" \
        "$out/2026.1/Vivado/settings64.sh" \
        "$out/2026.1/Vivado/settings64.csh" \
        --replace-fail \
          "$installRoot/2026.1" \
          "$installedRoot"

      runHook postInstall
    '';

    meta = {
      description = "AMD Vivado FPGA design suite";
      homepage = "https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html";
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
      sourceProvenance = with lib.sourceTypes; [
        binaryNativeCode
      ];
    };
  };

  /*
    Runtime FHS environment.

    This is separate from the installer environment because the installed
    Vivado binaries have different runtime requirements.
  */
  vivado = buildFHSEnv {
    pname = "vivado";
    inherit version;

    targetPkgs =
      pkgs: with pkgs; [
        bash
        coreutils
        unzip
        which
        nettools
        xdg-utils

        # GUI
        alsa-lib
        at-spi2-atk
        cairo
        cups
        dbus
        expat
        fontconfig
        freetype
        glib
        gsettings-desktop-schemas
        gtk2
        gtk3
        hicolor-icon-theme
        pango

        # OpenGL
        libGL
        libdrm

        # X11
        libx11
        libxcb
        libxcomposite
        libxcursor
        libxdamage
        libxext
        libxfixes
        libxi
        libxinerama
        libxkbcommon
        libxrandr
        libxrender
        libxscrnsaver
        libxtst

        # Other runtime dependencies
        graphviz
        libgcrypt
        libpng
        libsecret
        libusb1
        libuuid
        ncurses5
        openssl
        stdenv.cc.cc.lib
        zlib
      ];

    runScript = writeShellScript "vivado" ''
      set -euo pipefail

      vivadoRoot="${vivadoUnwrapped}/${version}/Vivado"

      source "$vivadoRoot/settings64.sh"

      exec "$vivadoRoot/bin/vivado" "$@"
    '';

    extraInstallCommands = ''
      install -Dm644 \
        "${vivadoUnwrapped}/${version}/Vivado/doc/images/Vivado_logo_full_dark.svg" \
        "$out/share/icons/hicolor/scalable/apps/vivado.svg"

      install -Dm644 \
        ${desktopItem}/share/applications/vivado.desktop \
        "$out/share/applications/vivado.desktop"
    '';

    passthru = {
      unwrapped = vivadoUnwrapped;
    };

    meta = vivadoUnwrapped.meta // {
      mainProgram = "vivado";
    };
  };

  desktopItem = makeDesktopItem {
    name = "vivado";

    desktopName = "AMD Vivado";
    genericName = "FPGA Design Suite";
    comment = "AMD Vivado FPGA design suite";

    exec = "vivado %F";
    icon = "vivado";

    terminal = false;
    startupNotify = true;

    categories = [
      "Development"
      "Electronics"
    ];
  };

in
vivado
