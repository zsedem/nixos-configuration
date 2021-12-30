{ config, ... }:


let
  #pkgs-local = (import (/etc/nixpkgs-fork) { config = config.nixpkgs.config; });
  pkgs = (import <nixos-unstable> { config = config.nixpkgs.config; });
  common-plugins = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "HOCON";
      publisher = "sabieber";
      version = "0.0.1";
      sha256 = "0mgyj7kxsx4acxc9nx63pwcwp9ckvrawj9pjln8wrnj5w9cdvbcv";
    }
  ];
  specific-vscode = (import ../packages/vscode.nix { inherit pkgs common-plugins;});
  vscodes = with pkgs.vscode-extensions; map (specific-vscode) [
      {
        name = "nix";
        exts = [
          bbenoist.nix
          jnoortheen.nix-ide
        ];
      }
      {
        name = "scala";
        exts = [
          scala-lang.scala
          scalameta.metals
        ];
      }
      {
        name = "rs";
        exts = [
          tamasfe.even-better-toml
          serayuzgur.crates
          matklad.rust-analyzer
        ];
      }
    ];
in {
  environment.systemPackages = vscodes;
}
