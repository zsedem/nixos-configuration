{
  config,
  pkgs,
  lib,
  ...
}:
{

  programs.neovim = {
    enable = true;
    configure = {
      customRC = lib.fileContents ./assets/init.vim;
    };
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
