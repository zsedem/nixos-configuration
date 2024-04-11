{ config, lib, ... }:

with lib;
let
    pkgs-stable = (import <nixpkgs> { config = config.nixpkgs.config; });
    pkgs = (import <nixos-unstable> { config = config.nixpkgs.config; });
    flags = config.zsedem;
    choosen-jdk = config.programs.java.package;
    onlyIf = pred: l: if pred then l else [];
in {
  options.zsedem =
    let flag = mkOption { type = types.bool; default = false; };
    in { scala = flag; rust = flag; k8s = flag; };

  config = with pkgs; {
    environment.systemPackages =
         [pkgs.vscode] ++ onlyIf (flags.scala) [
            (sbt.override { jre = choosen-jdk; })
            scalafmt
        ] ++ onlyIf (flags.rust) [
            rustup
            gcc
            llvmPackages.bintools-unwrapped
            cmakeMinimal
        ] ++ onlyIf (flags.k8s) [
            kubectl
            kubernetes-helm
        ];
  };
}
