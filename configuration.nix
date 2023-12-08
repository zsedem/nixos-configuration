{ config, pkgs, ... }:
{
  imports =
    [
      ./commons
      ./desktops/gnome.nix
      ./users/azsigmond.nix
    ];
}
