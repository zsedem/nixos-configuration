{ pkgs }:

let
  # this is the vimrc.nix from above
  vimrc   = pkgs.callPackage ./vimrc.nix {};
in
{
  customRC = vimrc;
  vam = {
    knownPlugins = pkgs.vimPlugins;

    pluginDictionaries = [
      { name = "youcompleteme"; }
    ];
  };
}
