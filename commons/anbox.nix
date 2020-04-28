{ config, lib, pkgs, ... }:

{
  virtualisation.anbox.enable = true;
  programs.adb.enable = true;
  users.users.azsigmond.extraGroups = [ "adbusers" ];
}
