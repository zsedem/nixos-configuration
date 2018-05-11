{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./desktops/gnome.nix
      ./commons/snapper.nix
      ./commons/nixos.nix
      ./commons/fonts.nix
      ./commons/systemdboot.nix
      ./commons/command-line-utils.nix
      ./commons/docker.nix
      ./commons/powertop.nix
      ./users/azsigmond.nix
      <nixpkgs/nixos/modules/programs/command-not-found/command-not-found.nix>
    ];

  environment.systemPackages = let
      stWithTmux = import ./packages/terminal.nix pkgs;
    in
      [ stWithTmux
        (import ./packages/mill.nix)
      ];

}
