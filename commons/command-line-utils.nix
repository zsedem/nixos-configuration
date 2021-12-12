{ config, pkgs, ... }:

{

  environment = {
    systemPackages = let
        vim = import ../packages/vim/default.nix pkgs;
      in
        (with pkgs; [
          bat 
          delta
          dialog
          file
          fzf
          jq
          gh 
          gitAndTools.gitFull 
          gnupg
          htop
          openssl
          pciutils
          pv
          telnet
          tig
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
