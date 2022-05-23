{ config, lib, ... }:

with lib;
let
    pkgs-stable = (import <nixpkgs> { config = config.nixpkgs.config; });
    pkgs = (import <nixos-unstable> { config = config.nixpkgs.config; });
    flags = config.zsedem;
    plugins = with pkgs.vscode-extensions; [
      usernamehw.errorlens
      streetsidesoftware.code-spell-checker
      redhat.vscode-yaml
      zxh404.vscode-proto3
      hocon
    #  ms-vsliveshare.vsliveshare
    ];
    onlyIf = pred: l: if pred then l else [];
    vscode-extension = settings: head (pkgs.vscode-utils.extensionsFromVscodeMarketplace [settings]);
    aws-toolkit-vscode = vscode-extension {
              name = "aws-toolkit-vscode";
              publisher = "AmazonWebServices";
              version = "1.37.0";
              sha256 = "0y9wsx9qlnz86bichkrr2f25nkkhmkksi85wvrd65kmp9mv52q48";
            };
    hocon = vscode-extension {
              name = "HOCON";
              publisher = "sabieber";
              version = "0.0.1";
              sha256 = "0mgyj7kxsx4acxc9nx63pwcwp9ckvrawj9pjln8wrnj5w9cdvbcv";
            };
    kddejong = {
      vscode-cfn-lint = vscode-extension {
            name = "vscode-cfn-lint";
            publisher = "kddejong";
            version = "0.21.0";
            sha256 = "1x7w97a34mbjx5pndlil7dhicjv2w0n58b60g5ibpvxlvy49grr2";
        };
    };
    tim-koehler = {
        helm-intellisense = vscode-extension {
            name = "helm-intellisense";
            publisher = "tim-koehler";
            version = "0.13.2";
            sha256 = "0g320yzmlb3gy18h4xvzzcxpbf16984ddvpkdizp0l9di4jzd1c8";
        };
    };
in {
  options.zsedem =
    let flag = mkOption { type = types.bool; default = true; };
    in { scala = flag; rust = flag; nix = flag; k8s = flag; py = flag; aws = flag; };

  config = with pkgs; with vscode-extensions; {
    environment.systemPackages =
        plugins ++ [pkgs-stable.vscode] ++ onlyIf (flags.scala) [
            (sbt.override { jre = jdk; })
            jdk
            scalafmt
            scala-lang.scala
            scalameta.metals
        ] ++ onlyIf (flags.rust) [
            rustup
            gcc
            llvmPackages.bintools-unwrapped
            cmakeMinimal
            tamasfe.even-better-toml
            serayuzgur.crates
            matklad.rust-analyzer
        ] ++ onlyIf (flags.nix) [
            nix-prefetch-git
            nixpkgs-fmt
            rnix-lsp
            bbenoist.nix
            jnoortheen.nix-ide
        ] ++ onlyIf (flags.k8s) [
            kind
            kubectl
            kubernetes-helm
            tim-koehler.helm-intellisense
        ] ++ onlyIf (flags.py) [
            ms-python.python
        ] ++ onlyIf (flags.aws) [
          kddejong.vscode-cfn-lint
          python39Packages.cfn-lint
        ];
  };
}
