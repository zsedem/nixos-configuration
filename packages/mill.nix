with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "mill";
  version = "0.2.0-11";
  src = fetchurl {
    url = "https://github.com/lihaoyi/mill/releases/download/0.2.0/0.2.0-11-13d026";
    sha256 = "fcfc30b2eaaaf09abec117891f5431a941a2ca1a63d64b0515ee74e6d601815e";
  };
  buildCommand = ''
    mkdir -p $out/bin
    cp $src $out/bin/mill
    chmod +x $out/bin/mill
  '';
}
