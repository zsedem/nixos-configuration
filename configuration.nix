{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./desktops/gnome.nix
      ./commons/snapper.nix
      ./commons/nixos.nix
      ./commons/systemdboot.nix
      ./commons/command-line-utils.nix
      ./commons/docker.nix
      ./users/azsigmond.nix
      <nixpkgs/nixos/modules/programs/command-not-found/command-not-found.nix>
    ];

  environment.systemPackages = let
      stWithTmux = import ./packages/terminal.nix pkgs;
    in
      [ stWithTmux ];

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = [
      # fonts for gnome
      pkgs.dejavu_fonts pkgs.cantarell_fonts
      (import ./packages/monofur.nix)
    ];
  };

  networking.networkmanager.useDnsmasq = true;
}
