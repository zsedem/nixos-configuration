{ ... }:
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
in
 {
   security.pki.certificateFiles = certificateFiles;
 }

