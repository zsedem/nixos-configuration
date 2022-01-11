{ pkgs ? import <nixpkgs> {}, ... }:
# Use this to test this file
# echo -e ':p (import ./certs.nix {}).security.pki.certificateFiles' | nix repl
with builtins;
let
  certs-dir = ../../certs;
  dir-content = attrValues (mapAttrs (name: value: {inherit name; file = certs-dir + "/${name}"; type = value; }) (readDir certs-dir));
  certificateFiles =
    if (pathExists certs-dir) then
      concatMap ({name, file, type}:
        if all (ignoredname: name != ignoredname) [".gitignore" "README.md"]
          then [file]
          else []
      ) dir-content
    else [];
  java-key-store = pkgs.stdenv.mkDerivation {
    name = "java-key-store";

    srcs = certificateFiles;
    phases = "installPhase";
    buildInputs = [ pkgs.jdk ];
    installPhase = ''
      echo "creating $out"
      cp ${pkgs.jdk}/lib/openjdk/lib/security/cacerts $out
      chmod +w $out
      ls -al $out;
      '' + (concatStringsSep "\n" (map (file: ''
        keytool -importcert \
          -noprompt \
          -alias ${baseNameOf file} \
          -keystore "$out" \
          -storepass changeit \
          -file ${file}
      '') certificateFiles));
  };
in
 {
   security.pki.certificateFiles = certificateFiles;
   environment.etc."java/cacerts" = {
     source = java-key-store;
   };
 }

