{ config, lib, ... }:

with lib;
let 
    pkgs = (import <nixos-unstable> { config = config.nixpkgs.config; });
    flags = config.zsedem;
    plugins = [];
    onlyIf = pred: l: if pred then l else [];
    hocon = pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
              name = "HOCON";
              publisher = "sabieber";
              version = "0.0.1";
              sha256 = "0mgyj7kxsx4acxc9nx63pwcwp9ckvrawj9pjln8wrnj5w9cdvbcv";
            }];
in {
  options.zsedem = 
    let flag = mkOption { type = types.bool; default = true; };
    in { scala = flag; rust = flag; nix = flag; };
  
  config = with pkgs; with vscode-extensions; {
    environment.systemPackages =
        onlyIf (flags.scala) [
            (sbt.override { jre = jdk11; })
            jdk11
            scalafmt
            (import ../packages/vscode.nix {
                inherit pkgs;
                name = "scala";
                plugins = plugins ++ hocon ++ [ scala-lang.scala scalameta.metals ];
            })
        ] ++ onlyIf (flags.rust) [
            rustup
            gcc
            llvmPackages.bintools-unwrapped
            cmakeMinimal
            (import ../packages/vscode.nix {
                inherit pkgs;
                name = "rs";
                plugins = plugins ++ hocon ++ [ tamasfe.even-better-toml serayuzgur.crates matklad.rust-analyzer ];
            })
        ] ++ onlyIf (flags.nix) [
            nix-prefetch-git
            nixpkgs-fmt
            rnix-lsp
            (import ../packages/vscode.nix { 
                inherit pkgs;
                name = "nix";
                plugins = hocon ++ [ bbenoist.nix jnoortheen.nix-ide ];
            })
        ];
  };
}
