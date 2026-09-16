{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
  makeDesktopItem,
  copyDesktopItems,
  wineWow64Packages,
}:

let
  launcher = replaceVars ./ltspice {
    wine = "${wineWow64Packages.waylandFull}/bin/wine";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ltspice";
  version = "26.0.2";

  src = fetchurl {
    url = "https://LTspice.analog.com/download/${finalAttrs.version}/LTspice64.msi";
    hash = "sha256-SF2r0tfYKT3nM6OZcZ9lOO/aSlS0ixgaFOBycRhphNM=";
  };

  nativeBuildInputs = [
    copyDesktopItems
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 "$src" \
      "$out/share/ltspice/LTspice64.msi"

    install -Dm755 ${launcher} \
      "$out/bin/ltspice"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ltspice";
      desktopName = "LTspice";
      exec = "ltspice %F";
      terminal = false;

      categories = [
        "Science"
        "Engineering"
        "Electronics"
      ];
    })
  ];

  meta = {
    description = "Analog Devices LTspice circuit simulator";
    homepage = "https://www.analog.com/ltspice";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    mainProgram = "ltspice";
  };
})
