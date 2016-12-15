{ pkgs, ... }:

let
  termContent = ''
      #!/bin/sh
      exec st -f "monofur:pixelsize=27:antialias=true:autohint=true" "$@"
    '';
  attachTmux = ''
      #!/bin/sh
      unset TMUX
      exec term -e sh -c "tmux -q has-session && exec tmux attach-session || exec tmux"
    '';
  installPhaseScript = ''
     TERMINFO=$out/share/terminfo make install PREFIX=$out
     echo '${termContent}' > $out/bin/term
     chmod +x $out/bin/term
     echo '${attachTmux}' > $out/bin/attach-tmux
     chmod +x $out/bin/attach-tmux
   '';


in
  pkgs.stdenv.lib.overrideDerivation pkgs.st (attrs: {
           installPhase = installPhaseScript;
  })
