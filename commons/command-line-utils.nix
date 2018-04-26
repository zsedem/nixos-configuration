{ config, pkgs, ... }:

{

  environment = {
    systemPackages = let
        vim = import ../packages/vim/default.nix pkgs;
      in
        (with pkgs; [
          xclip fzf tmux tldr
          gitAndTools.gitFull gitAndTools.diff-so-fancy gitAndTools.hub tig
          zip unzip
          openssl gnupg
          vim
          htop pstree
          file tree dialog
          telnet
          pciutils usbutils
        ]);
  };
  programs.zsh.enable = true;
}
