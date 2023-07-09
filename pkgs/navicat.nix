{ appimageTools, lib, fetchurl }:

let
  name = "navicat";
  version = "16.1.7";
  # Minor versions are released using the same file name
  versionItems = builtins.splitVersion version;
  majorVersion = (builtins.elemAt versionItems 0);

  appimageContents = appimageTools.extract {
    inherit name src;
  };

  src = fetchurl {
    url = "https://download3.navicat.com/download/navicat${majorVersion}-premium-en.AppImage";
    hash = "sha256-noh1b9qegZJlxSicmOXTjDyjoxGMPDfCS7G2OeWPM8A=";
  };
in

appimageTools.wrapType1 rec {
  inherit name src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    ln -s ${appimageContents}/navicat.desktop $out/share/applications/navicat.desktop
    cp -r ${appimageContents}/usr/share/icons/ $out/share/
  '';

  extraPkgs = pkgs: [ ];

  meta = with lib; {
    description = "Navicat Premium 16";
    homepage = "https://www.navicat.com/";
    license = with licenses; [ unfree ];
    platforms = [ "x86_64-linux" ];
  };
}
