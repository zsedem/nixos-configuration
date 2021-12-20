{ config, ... }:

let
  # I only follow the stable nixos release branch, because I want a stable OS, but
  # when it comes to interactive command line tools, the newer the better.
  pkgs = (import <nixos-unstable> { config = config.nixpkgs.config; });

in {

  environment = {
    systemPackages = let
        vim              = import ../packages/vim/default.nix pkgs;
        skimAlternatives = pkgs.symlinkJoin {
                            name = "skim";
                            paths = [
                              (pkgs.writeShellScriptBin "git-rg" ''
                                  set -e # Easiest way to not enter vim if sk exits due to interrupt
                                  SK_RESULT="$(
                                    ${pkgs.ripgrep}/bin/rg \
                                      --line-number --color ansi "$@" . | \
                                      ${pkgs.skim}/bin/sk --bind \
                                      'alt-j:preview-down,alt-k:preview-up,ctrl-e:execute( {})' \
                                       --ansi  \
                                       --preview "${./assets/preview.sh} {}" \
                                  )"
                                  if [[ ! -z "$SK_RESULT" ]]; then
                                    exec ${./assets/vim-edit.sh} "$SK_RESULT"
                                  else
                                    exit 1
                                  fi
                              '')
                              (pkgs.writeShellScriptBin "sk-nvim" ''
                                export SKIM_DEFAULT_COMMAND="${pkgs.fd}/bin/fd --type f -I"
                                exec nvim -p $( ${pkgs.skim}/bin/sk -m \
                                  --preview '${pkgs.bat}/bin/bat --color=always --style=numbers --line-range=:500 {}')
                              '')
                              (pkgs.writeShellScriptBin "fzf" ''
                                exec ${pkgs.skim}/bin/sk "$@"
                              '')
                              pkgs.skim
                            ];
                          };
      in
        (with pkgs; [
          bat
          bat-extras.batgrep
          delta
          dialog
          fd
          file
          ripgrep
          skimAlternatives
          jq
          gh 
          gitAndTools.gitFull 
          gnupg
          htop
          openssl
          pciutils
          pv
          telnet
          gitui
          tldr
          tmux
          tree
          unzip
          usbutils
          vim
          xclip
          zip
        ]);
  };
  programs.zsh.enable = true;
}
