{ ... }:
# Use this to test this file
# echo -e ':p (import ./certs.nix {}).security.pki.certificateFiles' | nix repl
with builtins;
let
  certs-dir = ./.;
  dir-content = attrValues (mapAttrs (name: value: {inherit name; file = certs-dir + "/${name}"; type = value; }) (readDir certs-dir));
  nixFiles = 
    if (pathExists certs-dir) then
      concatMap ({name, file, type}:
        if all (ignoredname: name != ignoredname) ["default.nix"] && (match ".*\\.nix" name != null)
          then [file]
          else []
      ) dir-content
    else [];
in
 {
   imports = nixFiles;
 }