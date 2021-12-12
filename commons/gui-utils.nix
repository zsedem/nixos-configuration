{config, pkgs, ...}: 
{
  environment.systemPackages = let
      stWithTmux = import ../packages/terminal.nix pkgs;
    in
      with pkgs; [ stWithTmux
        flameshot
        google-chrome
        vlc
      ];


}