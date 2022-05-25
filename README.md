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

## Java jks setup with custom certificates

`commons/java.nix` contains a hacky way to always use custom
certificates added to the config. (Works with the above helper)

## Btrfs snapshots with snapper

The config in `disk-setup/btrfs-with-snapper.nix` defines a system
installed on btrfs subvolumes and uses snapperd to create snapshots
automatically for easier.

## Firefox Opener
The config in `commons/firefox.nix` defines some nice support for firefox containers, so
you can choose for every link clicked outside of firefox (like a chat application), that
what container will be used for them interactively.

```nix
{
  zsedem.firefox-opener = {
    enable = true;
    containers = [ # You might add only the containers, which you want to use for pages from external applications
      { name = "Work"; color = "purple"; }  # Color is used in the interactive page
      { name = "Personal"; color = "red"; }
    ];
    host-mapping = {
      "www.fastmail.com" = "Personal";
      "github.com" = "Work";
    };
  };
}
```

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
    <zsedem-config/disk-setup/btrfs-with-snapper.nix>
    <zsedem-config/hardware/t470.nix>
  ];

  boot.initrd.luks.devices."BtrfsRoot".device = "/dev/nvme0n1p2";
  zsedem.btrfs-root = "/dev/mapper/BtrfsRoot";
  zsedem.certificatesFolder = ./certs;

  fileSystems."/boot" = { ... };

  zsedem.zoom = true;
  zsedem.kafka = true;
  programs.java.enable = true;
}
```
