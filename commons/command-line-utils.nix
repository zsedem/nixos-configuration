{ config, ... }:

let 
  # I only follow the stable nixos release branch, because I want a stable OS, but
  # when it comes to interactive command line tools, the newer the better.
  pkgs = import <nixos-unstable> {};
in {

  environment = {
    systemPackages = let
        vim             = import ../packages/vim/default.nix pkgs;
        skimWithPreview = pkgs.symlinkJoin {
                            name = "skim";
                            paths = [
                              (pkgs.writeShellScriptBin "sk-nvim" ''
                                export SKIM_DEFAULT_COMMAND="${pkgs.fd}/bin/fd --type f -I"
                                exec nvim -p $( ${pkgs.skim}/bin/sk -m \
                                  --preview '${pkgs.bat}/bin/bat --color=always --style=numbers --line-range=:500 {}')
                              '')
                              (pkgs.writeShellScriptBin "fzf" ''
                                exec s${pkgs.skim}/bin/sk "$@"
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
          skimWithPreview
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
