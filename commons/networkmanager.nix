{  config, pkgs, ...}:

{
  networking.networkmanager.dns = "dnsmasq";
  networking.networkmanager.enable = true;
}
