{ config, pkgs, ... }:
{
  imports =
    [
      ./locals
      ./commons/command-line-utils.nix
      ./commons/docker.nix
      ./commons/fonts.nix
      ./commons/gui-utils.nix
      ./commons/rust.nix
      ./commons/nixos
      ./commons/snapper.nix
      ./commons/systemdboot.nix
      ./commons/vscode.nix
      ./desktops/gnome.nix
      ./hardware/t470.nix
      ./users/azsigmond.nix
      <nixpkgs/nixos/modules/programs/command-not-found/command-not-found.nix>
    ];

}
