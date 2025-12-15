{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "maple-font";
  version = "7.9";

  src = fetchzip {
    url = "https://github.com/subframe7536/maple-font/releases/download/v${version}/MapleMono-NF.zip";
    hash = "sha256-N7wQ/dCtdwha/VjM7/y7Fid3371t2S7oUE5vEtBeo0g=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open source monospace font with round corner and ligatures";
    homepage = "https://github.com/subframe7536/maple-font";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
