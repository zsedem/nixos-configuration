{
  lib,
  pkgs,
  stdenv,
  fetchurl,
}:

let
  version = "2.14.0";

in
stdenv.mkDerivation {
  inherit version;
  pname = "vanta-agent";
  dontBuild = true;
  src = fetchurl {
    url = "https://vanta-agent-repo.s3.amazonaws.com/targets/versions/${version}/vanta-amd64.deb";
    hash = "sha256-IYRaXpR3z7Yfd5qcHZryya2UzX9rldjdB27/uTXufUk=";
  };

  nativeBuildInputs = [
    pkgs.dpkg
    pkgs.autoPatchelfHook
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    # binaries + certificate
    mkdir -p $out
    cp -r var $out/

    # systemd service
    mkdir -p $out/lib
    cp -r usr/lib/systemd $out/lib

    # mainProgram
    mkdir -p $out/bin
    cp -r var/vanta/vanta-cli $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "Vanta Agent";
    homepage = "https://vanta.com";
    maintainers = with lib.maintainers; [ matdibu ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "vanta-cli";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };

}
