{ pkgs, lib, stdenv, fetchurl, autoPatchelfHook, makeWrapper, ... }:

let
  # Use the AppImage version of Anytype to avoid compilation issues
  pname = "anytype";
  version = "0.53.1";
in
pkgs.appimageTools.wrapType2 {
  inherit pname version;
  name = "anytype";

  src = fetchurl {
    url = "https://github.com/anyproto/anytype-ts/releases/download/v${version}/Anytype-${version}.AppImage";
    sha256 = "sha256-Gr+RO804AzQbAxxsGIOAd8/8/z1b8hfUaBqWYqCQnME=";
  };

  extraPkgs = pkgs: with pkgs; [
    libsecret
  ];

  meta = with lib; {
    description = "Local-first, P2P note-taking app";
    homepage = "https://anytype.io";
    platforms = platforms.linux;
  };
}
