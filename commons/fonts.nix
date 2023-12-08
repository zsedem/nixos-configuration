{ config, pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = [
      # fonts for gnome
      pkgs.dejavu_fonts pkgs.cantarell-fonts
      (pkgs.nerdfonts.override { fonts = [ "Monofur" ]; })
    ];
  };
}
