{ config, lib, pkgs, ... }:

{
  security.pam.services.zsedem.enableKwallet = true;
  services.xserver = {
      enable = true;
      displayManager.sddm = {
          enable = true;
          extraConfig = ''
                        [Autologin]
                        User=zsedem
                        Session=plasma.desktop
                        '';
      };
      desktopManager.plasma5 = {
          enable = true;
      };
    };
  hardware.pulseaudio.enable = true;
  environment.systemPackages  = [ pkgs.ksshaskpass ];
  networking.networkmanager.enable = true;
}
