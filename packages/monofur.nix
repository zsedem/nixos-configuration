with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "monofur";
  src = fetchurl {
    url = "https://github.com/chrissimpkins/codeface/blob/master/fonts/monofur/monof55.ttf?raw=true";
    sha256 = "025676779b4ea99781930b6916ce3c575f9bfda77e1d726e8d70032c007b2b44";
  };
    
  buildCommand = ''
    mkdir -p $out/share/fonts/truetype/monofur
    cd $out/share/fonts/truetype/monofur
    cp $src ./monofur.ttf
  '';
  
  buildInputs = [ ];
}
