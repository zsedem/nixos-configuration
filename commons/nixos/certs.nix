{ pkgs ? import <nixpkgs> {}, config, lib, ...}:
with lib;


let
  certificateFiles =
    with builtins;
    certs-dir:
      let
        dir-content = attrValues (mapAttrs (name: value: {inherit name; file = certs-dir + "/${name}"; type = value; }) (readDir certs-dir));
      in
        if (pathExists certs-dir) then
          concatMap ({name, file, type}:
            if all (ignoredname: name != ignoredname) [".gitignore" "README.md"]
              then [file]
              else []
          ) dir-content
        else [];
in
 {
   options.zsedem.certificatesFolder = mkOption { type = types.path; default = null;};
   config = mkIf (config.zsedem.certificatesFolder != null) {
     security.pki.certificateFiles = certificateFiles config.zsedem.certificatesFolder;
   };
 }

