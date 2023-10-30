{config, lib, ...}:
let
  pkgs = (import <nixos-unstable> { config = config.nixpkgs.config; });
in {
  environment.systemPackages = with pkgs; [
    flameshot
#    postman
    firefox
    google-chrome
    deluge
    vlc
  ];
}
