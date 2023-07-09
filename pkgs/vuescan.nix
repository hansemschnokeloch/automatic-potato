# VueScan 
# see https://github.com/NixOS/nixpkgs/issues/217996 for details

{ pkgs
, stdenv
, fetchurl
, gnutar
, autoPatchelfHook
, glibc
, gtk2
, xorg
, libgudev
, requireFile
, undmg
, lib
}:

let

  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "vuescan";
  # Minor versions are released using the same file name
  version = "9.8.05";
  versionItems = builtins.splitVersion version;
  versionString = (builtins.elemAt versionItems 0) + (builtins.elemAt versionItems 1);

  src =
    let
      base = "https://www.hamrick.com/files/";
    in
      {
        x86_64-linux = fetchurl {
          url = "${base}/vuex64${versionString}.tgz";
          hash = "sha256-GweW2APbm6iaKj4aEM8Wb41gjEg3Q4r70dg1PqDtomg=";
        };
      }.${system} or throwSystem;

  meta = with lib; {
    description = "Scanner software supporting a wide range of devices";
    homepage = "https://hamrick.com/";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
    ];
  };

in

stdenv.mkDerivation rec {
  inherit pname version src meta;

  # Stripping the binary breaks the license form
  dontStrip = true;

  nativeBuildInputs = [
    gnutar
    autoPatchelfHook
  ];

  buildInputs = [
    glibc
    gtk2
    xorg.libSM
    libgudev
  ];

  desktopItem = pkgs.makeDesktopItem
    {
      type = "Application";
      name = "VueScan";
      exec = "vuescan";
      desktopName = "VueScan";
      icon = "vuescan";
    };

  unpackPhase = ''
    tar xfz $src
  '';

  installPhase = ''
    install -m755 -D VueScan/vuescan $out/bin/vuescan

    mkdir -p $out/share/icons/hicolor/scalable/apps/
    cp VueScan/vuescan.svg $out/share/icons/hicolor/scalable/apps/vuescan.svg 

    mkdir -p $out/lib/udev/rules.d/
    cp VueScan/vuescan.rul $out/lib/udev/rules.d/60-vuescan.rules

    mkdir -p $out/share/applications/

    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';
}
