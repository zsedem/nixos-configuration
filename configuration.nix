{ config, pkgs, ... }:
{
  imports =
    [
      ./commons
      ./desktops/gnome.nix
      ./users/azsigmond.nix
      <nixpkgs/nixos/modules/programs/command-not-found/command-not-found.nix>
    ];
}
