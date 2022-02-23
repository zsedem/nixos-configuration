{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, libjack2, ... }:

stdenv.mkDerivation rec {
  pname = "jackfreqd";
  version = "0.2.2-1";

  src = fetchFromGitHub {
    owner = "oleg68";
    repo = "jackfreqd";
    rev = version;
    sha256 = "15dizpz577lm648c2n86zr2fl4njsf3xif2i84lxfbhv2dpfqnk2";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libjack2 ];

  meta = {
    description = "jackfreqd is a variant of powernowd tailored for pro-audio work";
    homepage = "https://github.com/oleg68/jackfreqd";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
