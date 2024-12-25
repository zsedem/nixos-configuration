{ config, pkgs, ... }:
{
  imports =
    [
      ./commons
      ./desktops/gnome.nix
      ./users/azsigmond.nix
      ./packages/steam.nix # Does not enable anything by default
    ];
}
