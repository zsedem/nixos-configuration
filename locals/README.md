# Folder for local settings
Any `*.nix` file will be imported in to the root configuration.

The file should contain a function like the ones expected by
import:
```nix
{ pkgs, ... }:
{
    environment.systemPackages = [ pkgs.hello ];
}
```