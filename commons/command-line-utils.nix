{ config, ... }:

let
  stable = (import <nixos> { config = config.nixpkgs.config; });
  # I only follow the stable nixos release branch, because I want a stable OS, but
  # when it comes to interactive command line tools, the newer the better.
  pkgs = (import <nixos-unstable> { config = config.nixpkgs.config; });

  batCacheWithHocon = pkgs.stdenv.mkDerivation {
    name = "bat-config-with-hocon";
    src = pkgs.fetchFromGitHub {
      owner = "NeQuissimus";
      repo = "Sublime-Hocon";
      rev = "89169658fb2be384b7e85afacd5536149e248b8b";
      sha256 = "185mk9br1wfbcw0cyz6b43dfscy6a2gnfqgw02n1yjyfwsbbzswx";
    };
    buildPhase = ''
      export BAT_CACHE_PATH=./cache-dir
      export HOME=./
      export BAT_CONFIG_DIR=./.config/bat
      mkdir -p "$BAT_CONFIG_DIR/syntaxes/HOCON"
      mkdir -p $BAT_CACHE_PATH
      cp -r ./*.sublime-syntax "$BAT_CONFIG_DIR/syntaxes/HOCON"
      ls -Ral $(${pkgs.bat}/bin/bat --config-dir)
      ${pkgs.bat}/bin/bat cache --build
    '';
    installPhase = ''
      cp -r ./cache-dir $out
    '';
  };
in {

  environment = {
    systemPackages = let
      vim = import ../packages/vim/default.nix pkgs;
      skimAlternatives = pkgs.symlinkJoin {
        name = "skim";
        paths = [
          (pkgs.writeShellScriptBin "git-rg" ''
            SHELL=${pkgs.bash}/bin/bash
            set -e # Easiest way to not enter vim if sk exits due to interrupt
            SK_RESULT="$(
              ${pkgs.ripgrep}/bin/rg \
                --line-number --color ansi "$@" . | \
                ${pkgs.skim}/bin/sk --bind \
                'alt-j:preview-down,alt-k:preview-up,ctrl-e:execute( {})' \
                 --ansi  \
                 --preview "${./assets/preview.sh} {}" \
            )"
            if [[ ! -z "$SK_RESULT" ]]; then
              exec ${./assets/vim-edit.sh} "$SK_RESULT"
            else
              exit 1
            fi
          '')
          (pkgs.writeShellScriptBin "fzf" ''
            exec ${pkgs.skim}/bin/sk "$@"
          '')
          pkgs.skim
        ];
      };
      batConfigured = pkgs.symlinkJoin {
        name = "bat";
        paths = [
          (pkgs.writeShellScriptBin "bat" ''
            export BAT_CONFIG_PATH=${./assets/bat-config}
            export BAT_CACHE_PATH=${batCacheWithHocon}
            exec ${pkgs.bat}/bin/bat "$@"
          '')
          (pkgs.writeShellScriptBin "batman" ''
            export BAT_CONFIG_PATH=${./assets/bat-config}
            export BAT_CACHE_PATH=${batCacheWithHocon}
            exec ${pkgs.bat-extras.batman}/bin/batman "$@"
          '')
        ];
      };
    in (with pkgs; [
      batConfigured
      bat-extras.batgrep
      delta
      dialog
      envsubst
      pre-commit
      dyff
      tab-rs
      stable.alacritty
      fd
      file
      ripgrep
      skimAlternatives
      jq
      gh
      gitAndTools.gitFull
      gnupg
      htop
      oathToolkit
      openssl
      pciutils
      pv
      inetutils
      tldr
      tree
      python3
      unzip
      usbutils
      vim
      xclip
      zip
    ]);
  };
  programs.fish.enable = true;
}
