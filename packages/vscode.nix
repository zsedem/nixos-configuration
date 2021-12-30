{pkgs, common-plugins}:
{name, exts}:
let
     vscode-package = pkgs.vscode-with-extensions.override {
        vscodeExtensions = exts ++ common-plugins;
     };
in
    pkgs.writeShellScriptBin "code-${name}" ''
        VSCODE_USER_DIR="$HOME/.config/vscode/${name}"
        if [ -d "$VSCODE_USER_DIR" ]
        then
          true # Dir exists, nothing to do
        elif [ -f "$VSCODE_USER_DIR" ]
        then
            echo "$VSCODE_USER_DIR directory cannot be created, because a file exists under its name" > /dev/stderr
        else
            mkdir -p "$VSCODE_USER_DIR/User"
            ln -sf ../../_shared_config/User/keybindings.json "$VSCODE_USER_DIR/User/keybindings.json"
            ln -sf ../../_shared_config/User/settings.json "$VSCODE_USER_DIR/User/settings.json"
        fi
        exec ${vscode-package}/bin/code --user-data-dir "$VSCODE_USER_DIR" "$@"
    ''
