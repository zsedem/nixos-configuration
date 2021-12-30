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
