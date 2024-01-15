{config, lib, ...}:
with lib;
let
  # Set Zoom to release: 5.16.10.668
  pkgs = (
    import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/01962add7e97c051a6c2dd2a013d7e7c8ec2388a.tar.gz";
    }) {
	    config = config.nixpkgs.config;
	}
  );
  zoom-enabled = config.zsedem.zoom;
in {
  options.zsedem.zoom = mkOption { type = types.bool; default = false; };

  config = mkIf (zoom-enabled) {
    environment.systemPackages = [pkgs.zoom-us];
    xdg.mime.defaultApplications = {
      "x-scheme-handler/zoomtg" = "us.zoom.Zoom.desktop";
    };
  };
}
