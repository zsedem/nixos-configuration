with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "monofur";
  src = fetchurl {
    url = "http://eurofurence.net/monof_tt.zip";
    sha256 = "2d41ca991f342f9b74bc01433fba6c371fa7abcd5eaa45d8e71c9b8a2049055a";
  };
    
  buildCommand = ''
    mkdir -p $out/share/fonts/truetype
    cd $out/share/fonts/truetype
    unzip $src
  '';
  
  buildInputs = [ unzip ];
}
