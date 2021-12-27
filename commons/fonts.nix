{ config, pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = [
      # fonts for gnome
      pkgs.dejavu_fonts pkgs.cantarell_fonts
      (pkgs.nerdfonts.override { fonts = [ "Monofur" ]; })
    ];
  };
}
