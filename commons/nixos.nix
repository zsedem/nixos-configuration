# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  system = {
    stateVersion = "18.03";
    autoUpgrade = {
      enable = true;
      dates = "12:00";
    };
  };
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 20d";
    dates = "Mon 12:00:00";
  };
  nix.allowedUsers = [ "@wheel" ];
  nix.autoOptimiseStore = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  security.sudo = {
    enable = true;
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Budapest";

  programs.bash.enableCompletion = true;
}
