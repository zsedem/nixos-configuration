{ config, lib, ... }:

with lib;
let
    pkgs = (import <nixos-unstable> { config = config.nixpkgs.config; });
    flags = config.zsedem;
    plugins = with pkgs.vscode-extensions; [
      redhat.vscode-yaml
    #  ms-vsliveshare.vsliveshare
    ];
    onlyIf = pred: l: if pred then l else [];
    hocon = pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
              name = "HOCON";
              publisher = "sabieber";
              version = "0.0.1";
              sha256 = "0mgyj7kxsx4acxc9nx63pwcwp9ckvrawj9pjln8wrnj5w9cdvbcv";
            }];
    tim-koehler = {
        helm-intellisense = head (pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
            name = "helm-intellisense";
            publisher = "tim-koehler";
            version = "0.13.2";
            sha256 = "0g320yzmlb3gy18h4xvzzcxpbf16984ddvpkdizp0l9di4jzd1c8";
        }]);
    };
in {
  options.zsedem =
    let flag = mkOption { type = types.bool; default = true; };
    in { scala = flag; rust = flag; nix = flag; k8s = flag; py = flag; };

  config = with pkgs; with vscode-extensions; {
    environment.systemPackages =
        onlyIf (flags.scala) [
            (sbt.override { jre = jdk; })
            jdk
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
                plugins = plugins ++ [ bbenoist.nix jnoortheen.nix-ide ];
            })
        ] ++ onlyIf (flags.k8s) [
            kind
            kubectl
            kubernetes-helm
            (import ../packages/vscode.nix {
                inherit pkgs;
                name = "kube";
                plugins = plugins ++ [
                    tim-koehler.helm-intellisense
                ];
            })
        ] ++ onlyIf (flags.py) [
            (import ../packages/vscode.nix {
                inherit pkgs;
                name = "py";
                plugins = plugins ++ [
                    ms-python.python
                ];
            })
        ];
  };
}
