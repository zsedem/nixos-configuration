{ config, pkgs, ... }:
{
  imports =
    [
      ./commons/command-line-utils.nix
      ./commons/docker.nix
      ./commons/fonts.nix
      ./commons/gui-utils.nix
      ./commons/hiya.nix
      ./commons/rust.nix
      ./commons/nixos.nix
      ./commons/snapper.nix
      ./commons/systemdboot.nix
      ./desktops/gnome.nix
      ./hardware-configuration.nix
      ./hardware/t470.nix
      ./users/azsigmond.nix
      <nixpkgs/nixos/modules/programs/command-not-found/command-not-found.nix>
    ];

  networking.extraHosts =
    ''
    127.0.0.1 localhost kafka zookeeper
    '';
}
