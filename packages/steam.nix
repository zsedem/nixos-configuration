{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.steam ];
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
}
