{ config, pkgs, ... }:
{
  imports =
    [
      ./locals
      ./commons
      ./desktops/gnome.nix
      ./hardware/t470.nix
      ./users/azsigmond.nix
      <nixpkgs/nixos/modules/programs/command-not-found/command-not-found.nix>
    ];
}
