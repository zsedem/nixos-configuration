{ config, pkgs, ... }:

{

  environment = {
    systemPackages = let
        vim = import ../packages/vim/default.nix pkgs;
      in
        (with pkgs; [
          xclip fzf tmux tldr
          gitAndTools.gitFull gitAndTools.diff-so-fancy tig
          zip unzip openssl
          vim
          htop pstree tree telnet dialog
        ]);
  };
  programs.zsh.enable = true;
}
