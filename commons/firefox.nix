{config, lib, ...}:
with lib;
let
  # I only follow the stable nixos release branch, because I want a stable OS, but
  # when it comes to interactive tools, the newer the better.
  pkgs = (import <nixos-unstable> { config = config.nixpkgs.config; });
  firefox-opener-config = config.zsedem.firefox-opener;
in {
  options.zsedem.firefox-opener.enable = mkOption { type = types.bool; default = true; };
  options.zsedem.firefox-opener.containers = mkOption {
    type = with types; nonEmptyListOf (submodule { options = {
      name = mkOption { type = types.str; };
      color = mkOption { type = types.str; };
    };});
    default = [
      { name = "Work"; color = "purple"; }
      { name = "Personal"; color = "red"; }
    ];
  };
  options.zsedem.firefox-opener.host-mapping = mkOption {
    type = with types; attrsOf str;
    example = {
      "www.fastmail.com" = "Personal";
      "github.com" = "Work";
      "localhost:8080" = "Work";
    };
    default = {};
  };

  config = mkIf (firefox-opener-config.enable) {
    environment.etc."firefox-opener-config.json".text = builtins.toJSON firefox-opener-config;
    environment.systemPackages = [ pkgs.firefox ];
    environment.extraSetup = ''
      sed 's#Exec=firefox#Exec=${ ./assets/firefox-opener.py }#g' $out/share/applications/firefox.desktop > $out/share/applications/xxx.desktop
      mv $out/share/applications/xxx.desktop $out/share/applications/firefox.desktop
    '';
  };
}
