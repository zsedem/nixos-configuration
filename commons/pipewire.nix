{ config, pkgs, ... }:

with pkgs;
{
  services.pulseaudio.enable = false; # Use pipewire instead

  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.jack.enable = true;

  security.rtkit.enable = true;
  programs.noisetorch.enable = true;
  environment.systemPackages = [ noisetorch ];
}
