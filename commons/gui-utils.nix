{config, lib, ...}:
with lib;
let
  # I only follow the stable nixos release branch, because I want a stable OS, but
  # when it comes to interactive tools, the newer the better.
  pkgs = (import <nixos-unstable> { config = config.nixpkgs.config; });
  zoom-enabled = config.zsedem.zoom;
in {
  options.zsedem.zoom = mkOption { type = types.bool; default = false; };

  environment.systemPackages = with pkgs; [
    flameshot
    postman
    google-chrome
    deluge
    vlc
  ] ++ (if (zoom-enabled) then [zoom-us] else []);

  xdg.mime.defaultApplications = if (zoom-enabled) then {
    "x-scheme-handler/zoomtg" = "us.zoom.Zoom.desktop";
  } else {};
}
