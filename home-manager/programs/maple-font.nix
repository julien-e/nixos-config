{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "maple-font";
  version = "7.9";

  src = fetchzip {
    url = "https://github.com/subframe7536/maple-font/releases/download/v${version}/MapleMono-NF.zip";
    hash = "sha256:59098b87c895d871635d37680e88000ae2b2b25b55428195b228ec589e35fb89";
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
