{  config, pkgs, ...}:

{
  networking.networkmanager.useDnsmasq = true;
  networking.networkmanager.enable = true;
}
