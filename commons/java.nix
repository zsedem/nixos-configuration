{ config, lib, pkgs ? import <nixpkgs> {}, ... }:
# Creates new JDK packages with custom trustStore including system-wide certificates
with lib;
with builtins;
let
  certificateFiles = config.security.pki.certificateFiles;

  make-java-with-certs = base-jdk: pkgs.stdenv.mkDerivation (finalAttrs: {
    name = "${base-jdk.name}";

    srcs = certificateFiles;
    phases = "installPhase";
    installPhase = ''
      if ! [ -d ${base-jdk}/lib/openjdk ]; then
        echo "Update trust store update to handle jdk other than openjdk"
        exit 1
      fi
      mkdir -p $out
      # Copy everything
      cp -r ${base-jdk}/* $out/

      # Make the cacerts file writable and update it
      chmod -R +w $out
      ln -sf $out/lib/openjdk/lib/src.zip $out/lib/src.zip
      '' + (concatStringsSep "\n" (map (file: ''
        $out/bin/keytool -importcert \
          -noprompt \
          -alias ${baseNameOf file} \
          -keystore "$out/lib/openjdk/lib/security/cacerts" \
          -storepass changeit \
          -file ${file}
      '') certificateFiles)) + ''
      chmod -R -w $out
      '';

    # Preserve all attributes from the original JDK
    meta = base-jdk.meta or {};
    passthru = base-jdk.passthru // {
      home = "${finalAttrs.finalPackage}/lib/openjdk";
    };
  });

  java11 = make-java-with-certs pkgs.openjdk11;
  java17 = make-java-with-certs pkgs.openjdk17;
  java21 = make-java-with-certs pkgs.openjdk21;
in {
  config = mkIf config.programs.java.enable {
    programs.java.package = java21;
    environment.extraSetup = ''
      ln -s ${java11}/lib/openjdk $out/lib/openjdk11
      ln -s ${java17}/lib/openjdk $out/lib/openjdk17
      ln -s ${java21}/lib/openjdk $out/lib/openjdk21
    '';
  };
}
