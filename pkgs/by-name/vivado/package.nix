{
  lib,
  stdenvNoCC,

  requireFile,
  buildFHSEnv,
  makeDesktopItem,
  writeShellScript,

  # Installer tools
  bash,
  coreutils,
  findutils,
  gnugrep,
  gnused,
  gawk,

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
  libxft,
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

  sfdName = "FPGAs_AdaptiveSoCs_Unified_SDI_2026.1_0616_1700.tar";

  sfd = requireFile {
    name = sfdName;

    hash = "sha256-gYBzQGgTbeRSDVfMiU40vluybKMRyp4QtlNM/7wI8Fk=";

    url =
      "https://www.amd.com/en/support/downloads/adaptive-socs-and-fpgas/"
      + "development-tools/2026-1.html";

    message = ''
      Vivado ${version} is proprietary software and AMD requires the
      installer to be downloaded using an AMD account.

      Download:

        ${sfdName}

      Then add it as a fixed-output file:

        nix-store --add-fixed sha256 /path/to/${sfdName}

      Alternatively, use the equivalent fixed-output store operation
      supported by your Nix version.

      The hash in package.nix must match the downloaded file.
    '';
  };

  vivadoUnwrapped = stdenvNoCC.mkDerivation {
    pname = "vivado-unwrapped";
    inherit version;

    src = sfd;

    nativeBuildInputs = [
      bash
      coreutils
      findutils
      gnugrep
      gnused
      gawk
    ];

    dontConfigure = true;
    dontBuild = true;

    sourceRoot = "FPGAs_AdaptiveSoCs_Unified_SDI_2026.1_0616_1700";

    postUnpack = ''
      # AMD assumes a traditional FHS /bin/bash.
      # Patch its shell scripts so the installer can run in the Nix build env.
      patchShebangs .

      # xsetup contains one hard-coded /bin/rm which patchShebangs cannot touch.
      substituteInPlace xsetup \
        --replace-fail '/bin/rm' '${coreutils}/bin/rm'
    '';

    installPhase = ''
      runHook preInstall

      cp ${./install-config.txt} install-config.txt

      substituteInPlace install-config.txt \
        --replace-fail 'Destination=' 'Destination=$out'

      # AMD's installer ships its own JRE and native installer libraries.
      # These are not taken from nixpkgs.
      export LD_LIBRARY_PATH="${
        lib.makeLibraryPath [
          libxtst
          libx11
          libxext
          libxrender
          libxi
          libxft
          libxcb
          glib
          gtk2
          gtk3
          fontconfig
          freetype
          libuuid
          zlib
          openssl
          stdenv.cc.cc.lib
          ncurses5
        ]
      }:$LD_LIBRARY_PATH"

      ./xsetup \
        --agree XilinxEULA,3rdPartyEULA \
        --batch Install \
        --config install-config.txt

      runHook postInstall
    '';

    meta = {
      description = "AMD Vivado FPGA design suite, unwrapped";
      homepage = "https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html";
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  };

  vivadoLauncher = writeShellScript "vivado-launcher" ''
    set -e

    vivadoRoot="${vivadoUnwrapped}/${version}/Vivado"

    # Let AMD establish its expected environment.
    source "$vivadoRoot/settings64.sh"

    exec "$vivadoRoot/bin/vivado" "$@"
  '';

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
buildFHSEnv {
  pname = "vivado";
  inherit version;

  runScript = vivadoLauncher;

  targetPkgs =
    pkgs: with pkgs; [
      # Shell / general runtime
      bash
      coreutils
      which
      unzip
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

      # X11
      libdrm
      libGL
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

      # Misc
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

  extraInstallCommands = ''
    install -Dm644 \
      ${desktopItem}/share/applications/vivado.desktop \
      "$out/share/applications/vivado.desktop"

    install -Dm644 \
      "${vivadoUnwrapped}/${version}/Vivado/doc/images/Vivado_logo_full_dark.svg" \
      "$out/share/icons/hicolor/scalable/apps/vivado.svg"
  '';

  passthru.unwrapped = vivadoUnwrapped;

  meta = vivadoUnwrapped.meta // {
    mainProgram = "vivado";
  };
}
