{ config, pkgs, ... }:
{
  imports = [
    ./commons
    ./vanta/service.nix
    ./desktops/gnome.nix
    ./users/azsigmond.nix
    ./packages/steam.nix # Does not enable anything by default
  ];
}
