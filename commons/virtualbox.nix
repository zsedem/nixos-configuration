{ config, lib, pkgs, ... }:

{
  virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.headless = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
}
