{ config, pkgs, ... }:

{
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };
  environment.systemPackages = [ pkgs.networkmanagerapplet ];
}
