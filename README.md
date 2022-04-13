# nixos-configuration
My personal NixOS Configuration (most of it anyway)

## Disclaimer
You might run into modules, which are not imported by any of my
current installations, therefore it might even throw some error
during rebuild if you just copy-paste it.

# Reusable parts
## Locals folder
In this folder everything is imported by the `default.nix`
expression.

## Importing certificates
To make it easier to add certificates the `commons/nixos/certs.nix`
is created to import all certificates added to the certs folder

## VS Code wrapper script
Do you want different instances of VSCode at the same time?

Create a shared settings and settings files:
```sh
echo '{}' | .config/vscode/_shared_config/User/keybindings.json
echo '{}' | .config/vscode/_shared_config/User/settings.json
```

Use the function in `packages/vscode.nix` like this
```nix
{ pkgs, ...}:
let
  common-plugins = [ bbenoist.nix ];
  custom-vscode = (import ./vscode.nix { inherit pkgs common-plugins; });
in {
  environment.systemPackage =  with pkgs.vscode-extensions; [
    (custom-vscode { name = "nix"; exts = [ jnoortheen.nix-ide ]; }) # creates `code-nix` command
    (custom-vscode { name = "scala"; exts = [ scala-lang.scala ]; }) # creates `code-scala` command
  ];
}
```

the different vscode instances will create different configurations
under the `$HOME/.config/vscode` folder. It will look like this:
```
/home/azsigmond/.config/vscode/
├── nix
│   ├── Backups
|   ..........
│   └── User
│       ├── globalStorage
│       ├── keybindings.json -> ../../_shared_config/User/keybindings.json
│       ├── settings.json -> ../../_shared_config/User/settings.json
│       └── snippets
├── scala
│   ├── Backups
|   .....
│   ├── storage.json
│   └── User
│       ├── globalStorage
│       ├── keybindings.json -> ../../_shared_config/User/keybindings.json
│       ├── settings.json -> ../../_shared_config/User/settings.json
│       └── snippets
└── _shared_config
    └── User
        ├── keybindings.json
        └── settings.json
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
    ./hardware-configuration.nix
  ];
  environment.systemPackages = with pkgs; [
    awscli2           # Add any package only relevant to this installation
  ];
  # Just examples of values, which are respected by the zsedem-config channel
  zsedem.zoom = true;
  zsedem.scala = true;
  zsedem.kafka = true;
  programs.java.enable = true;
}
```