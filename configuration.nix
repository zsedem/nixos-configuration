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
#      ./commons/print.nix
      ./packages/steam.nix
      ./local.nix
      ./t470.nix
      ./users/azsigmond.nix
      <nixpkgs/nixos/modules/programs/command-not-found/command-not-found.nix>
    ];

  networking.extraHosts =
      ''
      127.0.0.1 localhost kafka zookeeper
      '';

  environment.systemPackages = let
      stWithTmux = import ./packages/terminal.nix pkgs;
    in
      with pkgs; [ stWithTmux
        (import ./packages/mill.nix)
        docker_compose
        google-chrome
        graphviz
        jq
        scalafmt
        libnotify
        mc
        openjdk
        postgresql
        slack
        vault
        vlc
      ];

  environment.etc."xdg/mimeapps.list" = {
    text = ''
      [Default Applications]
      x-scheme-handler/zoomtg=us.zoom.Zoom.desktop;
    '';
  };

}
