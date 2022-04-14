# nixos-configuration
My personal NixOS Configuration (most of it anyway)

## Disclaimer
You might run into modules, which are not imported by any of my
current installations, therefore it might even throw some error
during rebuild if you just copy-paste it.

# Reusable parts

## Importing certificates
To make it easier to add certificates the `commons/nixos/certs.nix`
is created to import all certificates added to the certs folder

## Using this repository as a channel (as I use it on my personal machine)
When setting up the `configuration.nix` in the installation process:
1. Add Channels
```
# nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
# nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
# nix-channel --add https://github.com/zsedem/nixos-configuration/archive/refs/heads/master.tar.gz zsedem-config
# nix-channel --update
```
2. Create a `configuration.nix`
```nix
{ config, ... }:

{
  imports = [
    <zsedem-config/configuration.nix>
    ./hardware-configuration.nix
  ];
  environment.systemPackages = with pkgs; [
    awscli2           # Add any package only relevant to this installation
  ];

  # Just examples of values, which are respected by the zsedem-config channel
  zsedem.zoom = true;
  zsedem.scala = true;
  zsedem.kafka = true;
  zsedem.certificatesFolder = ./certs;
  programs.java.enable = true;
}
```
