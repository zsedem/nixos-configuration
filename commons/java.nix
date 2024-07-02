{ config, lib, pkgs ? import <nixpkgs> {}, ... }:
# Creates a new trustStore for java with the system-wide certificates included
# and sets the _JAVA_OPTIONS variable pointing to the new trust store
# the trust store is symlinked to /etc/java/cacerts for conveinience
with lib;
with builtins;
let
  certificateFiles = config.security.pki.certificateFiles;
  choosen-jdk = (import <nixos-unstable> { config = config.nixpkgs.config; }).jdk21.override {};

  java-key-store = pkgs.stdenv.mkDerivation {
    name = "java-key-store";

    srcs = certificateFiles;
    phases = "installPhase";
    buildInputs = [ choosen-jdk ];
    installPhase = ''
      if ! [ -d ${choosen-jdk}/lib/openjdk ]; then
        echo "Update trust store update to handle jdk other than openjdk"
        exit 1
      fi
      cp ${choosen-jdk}/lib/openjdk/lib/security/cacerts $out
      chmod +w $out
      '' + (concatStringsSep "\n" (map (file: ''
        keytool -importcert \
          -noprompt \
          -alias ${baseNameOf file} \
          -keystore "$out" \
          -storepass changeit \
          -file ${file}
      '') certificateFiles));
  };
  java8 = pkgs.openjdk8;
  java17 = pkgs.openjdk17;
  java21 = pkgs.openjdk21;
in {
  config = mkIf config.programs.java.enable {
    programs.java.package = choosen-jdk;
    environment.etc."java/cacerts" = {
      source = java-key-store;
    };
    environment.sessionVariables = {
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd -Djavax.net.ssl.trustStore=/etc/java/cacerts";
    };
    environment.extraSetup = ''
      ln -s ${java8}/lib/openjdk $out/lib/openjdk8
      ln -s ${java17}/lib/openjdk $out/lib/openjdk17
      ln -s ${java21}/lib/openjdk $out/lib/openjdk21
    '';
  };
}

