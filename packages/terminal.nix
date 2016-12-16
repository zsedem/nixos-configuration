{ pkgs, makeDesktopItem, ... }:

let
  termContent = ''
      #!/bin/sh
      exec st -f "monofur:pixelsize=24:antialias=true:autohint=true" "$@"
    '';
  attachTmux = ''
      #!/bin/sh
      unset TMUX
      exec term -e sh -c "tmux -q has-session && exec tmux attach-session || exec tmux"
    '';
  attachTmuxDesktop = makeDesktopItem {
    name = "Tmux";
    exec = "attach-tmux";
    desktopName = "Tmux";
    genericName = "Tmux terminal emulator";
    categories = "Development;System";
  };
  termDesktop = makeDesktopItem {
    name = "Terminal";
    exec = "term";
    desktopName = "Terminal";
    genericName = "Terminal emulator";
    categories = "Development;System";
  };
  installPhaseScript = ''
     TERMINFO=$out/share/terminfo make install PREFIX=$out
     echo '${termContent}' > $out/bin/term
     chmod +x $out/bin/term
     echo '${attachTmux}' > $out/bin/attach-tmux
     chmod +x $out/bin/attach-tmux
     mkdir $out/share/applications
     ln -s '${attachTmuxDesktop}'/share/applications/* $out/share/applications
     ln -s '${termDesktop}'/share/applications/* $out/share/applications
   '';


in
  pkgs.stdenv.lib.overrideDerivation pkgs.st (attrs: {
           installPhase = installPhaseScript;
  })
