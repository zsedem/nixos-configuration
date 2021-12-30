rootDir:
# Use this to test this file
# echo -e ':p (import ./certs.nix {}).security.pki.certificateFiles' | nix repl
with builtins;
let
  dir-content = attrValues (mapAttrs (name: value: {inherit name; file = rootDir + "/${name}"; type = value; }) (readDir rootDir));
  nixFiles = 
    if (pathExists rootDir) then
      concatMap ({name, file, type}:
        if type != "directory"
        then
            if all (ignoredname: name != ignoredname) ["default.nix"] && (match ".*\\.nix" name != null)
            then [file]
            else []
        else
            let default-nix-in-folder = (file + "/default.nix"); in
            if (pathExists default-nix-in-folder)
            then [default-nix-in-folder]
            else []
      ) dir-content
    else [];
in
 {
   imports = nixFiles;
 }