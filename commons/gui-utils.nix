{config, ...}:
let
  # I only follow the stable nixos release branch, because I want a stable OS, but
  # when it comes to interactive tools, the newer the better.
  pkgs = (import <nixos-unstable> { config = config.nixpkgs.config; });
in {
  environment.systemPackages = with pkgs; [
    flameshot
    google-chrome
    deluge
    vlc
  ];
}
