{ config, lib, ... }:
let
  pkgs-unstable = (import <nixos-unstable> { config = config.nixpkgs.config; });
  pkgs-stable = (import <nixos> { config = config.nixpkgs.config; });
in {
  environment.systemPackages =
    (with pkgs-unstable; [ flameshot firefox windsurf uv ])
    ++ (with pkgs-stable; [
      deluge
      postman
      google-chrome
      cozy
      vlc
      calibre
      obsidian
      (slack.overrideAttrs (oldAttrs: {
        postInstall = ''
          ${oldAttrs.postInstall or ""}
          # Use sed to append '-g error' to get rid of unnecessary logs
          sed -i '/^Exec=/ s/$/ -g error/' $out/share/applications/slack.desktop
        '';
      }))
    ]);
}
