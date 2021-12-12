{  config, pkgs, ...}:

{
  #services.unbound.enable = true;
  networking.networkmanager.enable = true;
  environment.systemPackages = [ pkgs.networkmanagerapplet ];
}
