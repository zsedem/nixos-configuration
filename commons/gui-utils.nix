{config, ...}: 
let
  # I only follow the stable nixos release branch, because I want a stable OS, but
  # when it comes to interactive tools, the newer the better.
  pkgs = (import <nixos-unstable> { config = config.nixpkgs.config; });
in {
  environment.systemPackages = let
      stWithTmux = import ../packages/terminal.nix pkgs;
    in
      with pkgs; [
        stWithTmux
        flameshot
        google-chrome
        deluge
        vlc
      ];


}
