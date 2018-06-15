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
      with pkgs; [ stWithTmux
        (import ./packages/mill.nix)
        apacheKafka_0_11
        docker_compose
        google-chrome
        graphviz
        jq
        kafkacat
        kubectl
        libnotify
        mc
        oraclejdk8
        postgresql
        postman
        awscli
        sbt
        slack
        vault
        vlc
      ];

}
